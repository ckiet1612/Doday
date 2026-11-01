import Foundation
import G2Core
import GoogleMaps
import SwiftUI

struct PrototypePlace: Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let status: String
    let point: CGPoint
    // Canary coordinates near 0,0 — synthetic, never a real location and only compared with synthetic photo GPS.
    let coordinate: Coordinate
    let rating: String
    let hours: String
    static let fixtures: [Self] = [
        .init(
            id: "fixture-garden",
            name: "Doday Test Garden",
            subtitle: "Doday · synthetic",
            status: "OPERATIONAL",
            point: CGPoint(x: 0.35, y: 0.38),
            coordinate: .init(latitude: 0.01, longitude: 0),
            rating: "4,6 · 128",
            hours: "07:00–22:00"
        ),
        .init(
            id: "fixture-studio",
            name: "Doday Test Studio",
            subtitle: "Doday · synthetic",
            status: "OPERATIONAL",
            point: CGPoint(x: 0.68, y: 0.6),
            coordinate: .init(latitude: 0.012, longitude: 0.003),
            rating: "4,2 · 37",
            hours: "09:00–18:00"
        ),
        .init(
            id: "fixture-closed",
            name: "Doday Test Archive",
            subtitle: "Doday · synthetic",
            status: "CLOSED_PERMANENTLY",
            point: CGPoint(x: 0.24, y: 0.73),
            coordinate: .init(latitude: 0.05, longitude: 0),
            rating: "3,9 · 12",
            hours: "—"
        ),
    ]
    static func fixture(_ id: String?) -> Self? {
        fixtures.first { $0.id == id }
    }
}

enum LabScenario: String, CaseIterable, Identifiable {
    case normal, offline, noResults, multiple, googleError, quota, expired, closed, corruptImage, approximate, stale,
         noGPS, mismatch, moved
    var id: String {
        rawValue
    }

    func title(_ english: Bool) -> String {
        switch self {
        case .normal: return english ? "Normal" : "Bình thường"
        case .offline: return english ? "Offline" : "Mất mạng"
        case .noResults: return english ? "No place" : "Không có nơi"
        case .multiple: return english ? "Several candidates" : "Nhiều ứng viên"
        case .googleError: return english ? "Google error" : "Google lỗi"
        case .quota: return english ? "Quota exhausted" : "Hết quota"
        case .expired: return english ? "Field rights expired" : "Hết quyền dùng trường"
        case .closed: return english ? "Closed place" : "Nơi đóng cửa"
        case .corruptImage: return english ? "Image processing failure" : "Lỗi xử lý ảnh"
        case .approximate: return english ? "Approximate GPS" : "GPS gần đúng"
        case .stale: return english ? "Stale GPS" : "GPS cũ"
        case .noGPS: return english ? "No image GPS" : "Ảnh không GPS"
        case .mismatch: return english ? "Library >1 km away" : "Thư viện lệch >1 km"
        case .moved: return english ? "Moved place" : "Nơi đã chuyển"
        }
    }
}

@MainActor
final class PlacesLab: ObservableObject {
    @Published var trace: [String] = []
    @Published var scenario: LabScenario = .normal
    @Published var explicitRequests = 0
    @Published var passiveEvents = 0
    let mapsSDKInitialized = false
    // No approval/budget has been issued. Private xcconfig values do not constitute authorization.
    static let liveAuthorized = false
    var unavailable: Bool {
        scenario == .offline || scenario == .googleError || scenario == .quota
    }

    func search(_ query: String) async throws -> [PrototypePlace] {
        guard query.trimmingCharacters(in: .whitespacesAndNewlines).count >= TriggerPolicy.minimumQueryLength
        else { return [] }
        try await Task.sleep(nanoseconds: UInt64(TriggerPolicy.debounceMilliseconds) * 1_000_000)
        try Task.checkCancellation()
        record(.search)
        if unavailable {
            throw G2Error.unavailable
        }
        if scenario == .noResults || scenario == .expired {
            return []
        }
        let results = scenario == .closed ? [PrototypePlace.fixtures[2]] : PrototypePlace.fixtures
        return scenario == .multiple || scenario == .closed ? results : results
            .filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    /// Only reached after AppModel's privacy gate allowed a fresh sample; the fixture never receives the coordinate.
    func nearby() throws -> [PrototypePlace] {
        record(.nearby)
        if unavailable {
            throw G2Error.unavailable
        }
        if scenario == .noResults || scenario == .expired {
            return []
        }
        return Array(PrototypePlace.fixtures.prefix(5))
    }

    func record(_ event: APITrigger) {
        guard let descriptor = TriggerPolicy.request(for: event) else { passive(event); return }
        explicitRequests += 1
        trace.insert("fixture · \(event.rawValue) · fields:\(descriptor.fields.count)", at: 0)
        if trace.count > 50 {
            trace.removeLast()
        }
    }

    /// Passive events are counted to show the 0-request side of QP-02; they never acquire a request descriptor.
    func passive(_ event: APITrigger) {
        precondition(TriggerPolicy.request(for: event) == nil)
        passiveEvents += 1
    }

    func lockedProxyRequest(event: APITrigger, query: String? = nil, placeID: String? = nil) async throws -> Data {
        // Deliberately unreachable until a separate authorization change and audited proxy exist.
        guard Self.liveAuthorized,
              let descriptor = TriggerPolicy.request(for: event),
              let value = Bundle.main.object(forInfoDictionaryKey: "G2ProxyURL") as? String,
              let base = URL(string: value), base.scheme == "https",
              let token = Bundle.main.object(forInfoDictionaryKey: "G2ProxyToken") as? String, !token.isEmpty
        else { throw G2Error.liveLocked }
        var request = URLRequest(url: base.appendingPathComponent(event.rawValue))
        request.httpMethod = "POST"; request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query": query ?? "",
            "placeID": placeID ?? "",
            "mask": descriptor.fields,
        ])
        let session = URLSession(configuration: .ephemeral)
        defer { session.invalidateAndCancel() }
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw G2Error.unavailable }
        return data
    }
}

struct LiveGoogleMapProbe: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        guard PlacesLab.liveAuthorized,
              let key = Bundle.main.object(forInfoDictionaryKey: "G2MapsKey") as? String, !key.isEmpty,
              GMSServices.provideAPIKey(key) else { return UIView() }
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 3)
        let map = GMSMapView(options: options)
        map.isMyLocationEnabled = false
        return map
    }

    func updateUIView(_: UIView, context _: Context) {}
}
