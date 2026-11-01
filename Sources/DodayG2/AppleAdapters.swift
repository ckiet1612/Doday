@preconcurrency import AVFoundation
import CoreLocation
import CoreTransferable
import G2Core
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class CameraEngine: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "doday.g2.camera")
    private let output = AVCapturePhotoOutput()
    private var facing: AVCaptureDevice.Position = .back
    @Published var ready = false
    @Published var denied = false
    @Published var restricted = false
    @Published var busy = false
    @Published var unavailable = false
    var onPhoto: ((Data) -> Void)?
    // Internal probe from start request to running session; not Q-01, which starts at the app icon tap.
    var onReady: ((Double) -> Void)?
    private var startedAt: ContinuousClock.Instant?
    static var authorized: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    func start() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        restricted = status == .restricted
        var allowed = status == .authorized
        if status == .notDetermined {
            allowed = await AVCaptureDevice.requestAccess(for: .video)
        }
        guard allowed else { denied = !restricted; return }
        denied = false; startedAt = .now
        configure()
    }

    private func configure() {
        let session = session, output = output, facing = facing
        queue.async { [weak self] in
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: facing),
                  let input = try? AVCaptureDeviceInput(device: device)
            else {
                Task { @MainActor in self?.unavailable = true; self?.ready = false }; return
            }
            session.beginConfiguration(); session.sessionPreset = .photo
            session.inputs.forEach { session.removeInput($0) }
            guard session.canAddInput(input) else { session.commitConfiguration(); return }
            session.addInput(input)
            if session.outputs.isEmpty, session.canAddOutput(output) {
                session.addOutput(output)
            }
            session.commitConfiguration()
            if !session.isRunning {
                session.startRunning()
            }
            Task { @MainActor in
                guard let self else { return }
                self.ready = session.isRunning; self.unavailable = !session.isRunning
                if session.isRunning, let started = self.startedAt {
                    let elapsed = started.duration(to: .now).components
                    self.onReady?(Double(elapsed.seconds) * 1000 + Double(elapsed.attoseconds) / 1e15)
                }
                self.startedAt = nil
            }
        }
    }

    func stop() {
        ready = false
        let session = session
        queue.async {
            if session.isRunning {
                session.stopRunning()
            }
        }
    }

    func switchCamera() {
        guard ready, !busy else { return }
        ready = false; facing = facing == .back ? .front : .back; configure()
    }

    var facingFront: Bool {
        facing == .front
    }

    func capture() {
        guard ready, !busy else { return }
        busy = true
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        if let connection = output.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }
        output.capturePhoto(with: settings, delegate: self)
    }

    nonisolated func photoOutput(
        _: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let bytes = error == nil ? photo.fileDataRepresentation() : nil
        Task { @MainActor in
            busy = false
            if let bytes {
                onPhoto?(bytes)
            } else {
                unavailable = true
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    final class Preview: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        // layerClass guarantees the type, so the cast cannot fail.
        var preview: AVCaptureVideoPreviewLayer {
            // swiftlint:disable:next force_cast
            layer as! AVCaptureVideoPreviewLayer
        }
    }

    func makeUIView(context _: Context) -> Preview {
        let view = Preview(); view.preview.session = session; view.preview.videoGravity = .resizeAspectFill
        if let connection = view.preview.connection,
           connection.isVideoRotationAngleSupported(90)
        {
            connection.videoRotationAngle = 90
        }
        return view
    }

    func updateUIView(_: Preview, context _: Context) {}
}

struct PickedImage: Transferable {
    let bytes: Data
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(importedContentType: .image) { received in
            let bytes = try Data(contentsOf: received.file)
            guard bytes.count <= 20 * 1024 * 1024 else { throw G2Error.tooLarge }
            return PickedImage(bytes: bytes)
        }
    }
}

/// The manager is created on the main actor, so Core Location delivers its callbacks on the main thread.
@MainActor
final class LocationEngine: NSObject, ObservableObject, @preconcurrency CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let vault = RecognitionVault()
    private var pendingAccount: String?
    @Published var result = "idle"
    var onSample: ((LocationSample) -> Void)?
    override init() {
        super.init(); manager.delegate = self; manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func request(accountID: String) {
        discard(); pendingAccount = accountID
        switch manager.authorizationStatus {
        case .notDetermined: manager.requestWhenInUseAuthorization(); result = "permission"
        case .authorizedAlways, .authorizedWhenInUse: result = "requesting"; manager.requestLocation()
        case .denied: result = "denied"; pendingAccount = nil
        case .restricted: result = "restricted"; pendingAccount = nil
        @unknown default: result = "restricted"; pendingAccount = nil
        }
    }

    func discard() {
        vault.discard(); pendingAccount = nil; manager.stopUpdatingLocation()
    }

    func reset() {
        discard(); result = "idle"
    }

    func current() -> LocationSample? {
        vault.current()
    }

    /// Status for synthetic Lab samples too; never stores the coordinate.
    func noteReceipt(_ sample: LocationSample) {
        result = !sample.precise ? "approximate" : sample.ageAtReceipt > 60 ? "stale" : "received"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let account = pendingAccount else { return }
        if manager.authorizationStatus != .notDetermined {
            request(accountID: account)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let accountID = pendingAccount, let location = locations.last else { return }
        pendingAccount = nil; manager.stopUpdatingLocation()
        let sample = LocationSample(
            coordinate: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            accuracy: location.horizontalAccuracy,
            ageAtReceipt: max(0, Date().timeIntervalSince(location.timestamp)),
            receivedAtUptime: ProcessInfo.processInfo.systemUptime,
            precise: manager.accuracyAuthorization == .fullAccuracy,
            accountID: accountID
        )
        vault.accept(sample)
        onSample?(sample)
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        discard(); result = "unavailable"
    }
}
