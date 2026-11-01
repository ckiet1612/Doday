import G2Core
import PhotosUI
import SwiftUI

enum G2Style {
    static let green = Color(red: 0.10, green: 0.37, blue: 0.29)
    static let coral = Color(red: 0.75, green: 0.23, blue: 0.24)
}

struct RootView: View {
    @ObservedObject var model: AppModel
    @Environment(\.scenePhase) private var phase
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if model.accountID == nil {
                    HStack {
                        Label(
                            model.t(
                                "Chưa đăng nhập · cần đăng nhập trước khi chụp",
                                "Signed out · sign in before capturing"
                            ),
                            systemImage: "person.crop.circle.badge.questionmark"
                        )
                        .font(.subheadline)
                        Spacer(minLength: 8)
                        Button(model.t("Tài khoản mẫu A", "Fixture account A")) { model.login() }
                            .buttonStyle(.borderedProminent).accessibilityIdentifier("fixture.login")
                    }.padding(12).background(Color(.secondarySystemBackground))
                }
                if model.activeArea == 0 {
                    CameraScreen(model: model)
                } else {
                    MapScreen(model: model)
                }
            }
            .navigationTitle(model.activeArea == 0 ? "Doday" : model.t("Bản đồ", "Map"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("G2").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                        .accessibilityLabel(model.t(
                            "G2, dữ liệu mẫu, Google live khóa",
                            "G2, synthetic data, Google live locked"
                        ))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { model.profile = true } label: { Image(systemName: "person.crop.circle").font(.title3) }
                        .accessibilityLabel(model.t("Hồ sơ", "Profile")).accessibilityIdentifier("profile.open")
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                HStack(spacing: 0) {
                    areaButton(0, title: model.t("Camera", "Camera"), icon: "camera", id: "nav.camera")
                    areaButton(1, title: model.t("Bản đồ", "Map"), icon: "map", id: "nav.map")
                }.padding(.top, 10).padding(.bottom, 8).background(.bar)
            }
        }
        .tint(G2Style.green)
        .environment(\.locale, Locale(identifier: model.english ? "en" : "vi"))
        .sheet(isPresented: $model.profile) { ProfileScreen(model: model) }
        .sheet(item: Binding(
            get: { model.reviewID.map { ReviewIdentity(id: $0) } },
            set: { model.reviewID = $0?.id }
        )) { _ in
            ReviewScreen(model: model).interactiveDismissDisabled(model.processing)
        }
        .fullScreenCover(isPresented: Binding(get: { !model.onboarded }, set: { model.onboarded = !$0 })) {
            OnboardingScreen(model: model)
        }
        .g2ErrorAlert(model, active: !model.profile && model.reviewID == nil)
        .onChange(of: phase) {
            _, value in if value != .active {
                model.background()
            } else {
                model.refresh()
            }
        }
    }

    private func areaButton(_ index: Int, title: String, icon: String, id: String) -> some View {
        Button { model.activeArea = index } label: {
            VStack(spacing: 4) {
                Image(systemName: model.activeArea == index ? icon + ".fill" : icon).font(.title3); Text(title)
                    .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }.foregroundStyle(model.activeArea == index ? G2Style.green : Color.secondary)
            .accessibilityIdentifier(id).accessibilityAddTraits(model.activeArea == index ? .isSelected : [])
    }
}

private struct ReviewIdentity: Identifiable { let id: UUID }

extension View {
    /// Only the top-most presentation shows the error; an alert owned by a covered view would dismiss the sheet above it.
    func g2ErrorAlert(_ model: AppModel, active: Bool) -> some View {
        alert(
            model.t("Không thể hoàn tất", "Could not complete"),
            isPresented: Binding(get: { active && model.error != nil }, set: {
                if !$0 {
                    model.error = nil
                }
            })
        ) {
            Button("OK") { model.error = nil }
        } message: { Text(model.error ?? "") }
    }
}

struct OnboardingScreen: View {
    @ObservedObject var model: AppModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Doday").font(.largeTitle.bold()).padding(.top, 32)
                Picker(model.t("Ngôn ngữ", "Language"), selection: $model.english) {
                    Text("Tiếng Việt").tag(false); Text("English").tag(true)
                }
                .pickerStyle(.segmented)
                row(
                    "camera",
                    model.t("Chụp nhanh", "Capture fast"),
                    model.t(
                        "Mở app là vào Camera. Lưu không cần tiêu đề, bộ sưu tập hay chờ nhận diện.",
                        "The app opens on Camera. Saving needs no title, collection or recognition."
                    )
                )
                row(
                    "map",
                    model.t("Bản đồ của bạn", "Your map"),
                    model.t(
                        "Tìm, lưu Muốn ghé/Đã ghé và mở chỉ đường. Map dùng được cả khi chưa chụp.",
                        "Search, save Want to visit/Visited and open directions. Map works without capturing."
                    )
                )
                row(
                    "lock",
                    model.t("Chỉ mình bạn", "Only you"),
                    model.t(
                        "Bản 1.0 riêng tư. Ẩn vị trí và Ẩn trong vùng riêng tư đều bật sẵn.",
                        "Version 1.0 is private. Hide location and Hide in private zones are on by default."
                    )
                )
                Text(model.t(
                    "Bản thử G2 dùng tài khoản và địa điểm mẫu; không gọi Google.",
                    "This G2 prototype uses fixture accounts and places; it makes no Google calls."
                ))
                .font(.footnote).foregroundStyle(.secondary)
                Button { model.onboarded = true } label: { Text(model.t("Bắt đầu", "Get started")).frame(
                    maxWidth: .infinity,
                    minHeight: 44
                ) }
                .buttonStyle(.borderedProminent).accessibilityIdentifier("onboarding.start")
            }.padding(24)
        }.tint(G2Style.green)
    }

    private func row(_ icon: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon).font(.title2).foregroundStyle(G2Style.green).frame(width: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline); Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }.accessibilityElement(children: .combine)
    }
}

struct CameraScreen: View {
    @ObservedObject var model: AppModel
    @StateObject private var camera = CameraEngine()
    @Environment(\.scenePhase) private var phase
    @State private var selected: PhotosPickerItem?
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ZStack {
                    Color.black
                    if camera.ready {
                        CameraPreview(session: camera.session)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: camera.denied || camera
                                .restricted ? "camera.fill.badge.ellipsis" : "camera").font(.system(size: 38))
                            Text(cameraTitle).font(.headline).multilineTextAlignment(.center)
                            if camera.denied {
                                Text(model.t(
                                    "Vẫn chọn ảnh thư viện và dùng Bản đồ được.",
                                    "You can still choose a library photo and use Map."
                                ))
                                .font(.footnote).multilineTextAlignment(.center)
                                Button(model.t("Mở Cài đặt", "Open Settings")) { openSettings() }.buttonStyle(.bordered)
                            } else if !camera.unavailable && !camera.restricted {
                                Button(model.t("Bật camera", "Enable camera")) { Task { await camera.start() } }
                                    .buttonStyle(.bordered)
                                    .accessibilityIdentifier("camera.enable")
                            }
                        }.foregroundStyle(.white).padding(24)
                    }
                    VStack {
                        HStack {
                            Label(model.t("Chỉ mình bạn", "Only you"), systemImage: "lock.fill"); Spacer()
                            Button { model.nextHidden = !nextHidden } label: {
                                Label(
                                    nextHidden ? model
                                        .t("Ảnh sắp chụp: ẩn vị trí", "Next photo: location hidden") : model.t(
                                            "Ảnh sắp chụp: có vị trí",
                                            "Next photo: location on"
                                        ),
                                    systemImage: nextHidden ? "location.slash.fill" : "location.fill"
                                )
                                .padding(.horizontal, 10).frame(minHeight: 44).background(
                                    .white.opacity(nextHidden ? 0.18 : 0.32),
                                    in: Capsule()
                                )
                            }.accessibilityIdentifier("camera.hideNext")
                                .accessibilityHint(model.t(
                                    "Chỉ áp dụng cho ảnh sắp chụp",
                                    "Applies to the next photo only"
                                ))
                        }.font(.caption.weight(.semibold)).padding(.horizontal, 12).padding(.vertical, 4)
                            .background(.black.opacity(0.55))
                            // Overlay chips sit on the preview; capping their growth keeps the frame usable at AX sizes.
                            .dynamicTypeSize(...DynamicTypeSize.xxLarge)
                        Spacer()
                    }.foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit).clipped()
                .accessibilityElement(children: .contain)

                HStack(spacing: 28) {
                    PhotosPicker(selection: $selected, matching: .images, preferredItemEncoding: .current) {
                        Image(systemName: "photo.on.rectangle").font(.title2).frame(width: 48, height: 48)
                    }.disabled(model.accountID == nil || model.importing)
                        .accessibilityLabel(model.t("Chọn một ảnh", "Choose one photo"))
                        .accessibilityIdentifier("camera.library")
                    Button { camera.capture() } label: {
                        ZStack {
                            Circle().strokeBorder(G2Style.green, lineWidth: 3); Circle().fill(G2Style.green).padding(7)
                        }
                        .frame(width: 76, height: 76)
                    }.disabled(!camera.ready || camera.busy || model.accountID == nil)
                        .accessibilityLabel(model.t("Chụp ảnh", "Capture photo"))
                        .accessibilityIdentifier("camera.shutter")
                    Button { camera.switchCamera() } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera").font(.title2).frame(
                            width: 48,
                            height: 48
                        )
                    }
                    .disabled(!camera.ready || camera.busy)
                    .accessibilityLabel(camera.facingFront ? model.t(
                        "Đổi sang camera sau",
                        "Switch to back camera"
                    ) : model.t("Đổi sang camera trước", "Switch to front camera"))
                    .accessibilityIdentifier("camera.switch")
                }
                if model.accountID == nil {
                    Text(model.t(
                        "Đăng nhập để chụp. Bản đồ vẫn mở được.",
                        "Sign in to capture. Map is still available."
                    )).font(.footnote).foregroundStyle(.secondary)
                }
                if model.importing {
                    ProgressView(model.t("Đang đọc ảnh đã chọn", "Reading selected photo"))
                }
                if !camera.ready {
                    Button { model.capture(AppModel.fixtureImage(), origin: "fixture") } label: {
                        Label(
                            model.t("Chụp ảnh mẫu (không có camera)", "Capture fixture (no camera)"),
                            systemImage: "testtube.2"
                        )
                    }.buttonStyle(.bordered).disabled(model.accountID == nil).accessibilityIdentifier("camera.fixture")
                }
                HStack(spacing: 8) {
                    Image(systemName: model.policy.hide ? "location.slash" : "location")
                    Text((model.policy.hide ? model.t(
                        "Mặc định ảnh mới: ẩn vị trí (Cài đặt).",
                        "New-photo default: location hidden (Settings)."
                    )
                        : model.t(
                            "Mặc định ảnh mới: có vị trí; vùng riêng tư vẫn được kiểm tra.",
                            "New-photo default: location on; private zones still checked."
                        ))
                        + (model.nextHidden == nil ? "" : model.t(
                            " Chip trên chỉ đổi ảnh sắp chụp.",
                            " The chip above changes the next photo only."
                        )))
                }.font(.footnote).foregroundStyle(.secondary).padding(.horizontal, 20)
                if model.saveNotice {
                    Label(
                        model.t("Đã lưu trên máy · chưa đồng bộ", "Saved on device · not synced"),
                        systemImage: "checkmark.circle"
                    )
                    .font(.footnote).foregroundStyle(G2Style.green)
                }
            }.padding(.bottom, 24)
        }
        .onAppear {
            camera.onPhoto = { model.capture($0, origin: "camera") }
            camera.onReady = { model.recordCameraReady($0) }
            if CameraEngine.authorized {
                Task { await camera.start() }
            }
        }
        .onDisappear { camera.stop() }
        .onChange(of: phase) { _, value in
            if value == .active {
                if CameraEngine.authorized && !camera.ready {
                    Task { await camera.start() }
                }
            } else {
                camera.stop()
            }
        }
        .onChange(of: selected) { _, item in
            guard let item else { return }
            selected = nil
            // The model binds the import to the signed-in session, so a late result never lands in another account.
            model.importPhoto { try await item.loadTransferable(type: PickedImage.self)?.bytes }
        }
    }

    private var nextHidden: Bool {
        model.nextHidden ?? model.policy.hide
    }

    private var cameraTitle: String {
        if camera.denied {
            return model.t("Camera chưa được cấp quyền", "Camera access denied")
        }
        if camera.restricted {
            return model.t(
                "Camera bị hạn chế trên thiết bị này",
                "Camera is restricted on this device"
            )
        }
        if camera.unavailable {
            return model.t("Không có camera khả dụng", "Camera unavailable")
        }
        return model.t("Khoảnh khắc của bạn", "Your private moment")
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

struct ReviewScreen: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var location: LocationEngine
    @State private var title = ""
    @State private var choosing = false
    @State private var mismatch: PrototypePlace?
    @State private var deleting = false
    init(model: AppModel) {
        self.model = model; location = model.location
    }

    private var draft: DraftSummary? {
        model.reviewDraft
    }

    private var attached: PrototypePlace? {
        PrototypePlace.fixture(draft?.placeID)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let id = model.reviewID, let url = model.store?.imageURL(id),
                       let image = UIImage(contentsOfFile: url.path)
                    {
                        Image(uiImage: image).resizable().scaledToFit().frame(maxWidth: .infinity)
                            .accessibilityLabel(model.t(
                                "Ảnh khoảnh khắc",
                                "Moment photo"
                            ))
                    } else {
                        ContentUnavailableView(
                            model.t("Nguồn đã lưu trên máy", "Original saved on device"),
                            systemImage: "photo.badge.checkmark",
                            description: Text(model.processing ? model.t("Đang xử lý ảnh", "Processing image") : model
                                .t(
                                    "Cần xử lý lại ảnh",
                                    "Image processing needed"
                                ))
                        )
                        .frame(minHeight: 180)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Label(model.t("Đã lưu trên máy", "Saved on device"), systemImage: "checkmark.circle.fill")
                                .font(.subheadline.weight(.medium)).foregroundStyle(G2Style.green)
                                .accessibilityIdentifier("state.local")
                            Spacer()
                            Label(model.t("Chỉ mình bạn xem được", "Only you can see this"), systemImage: "lock.fill")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        if let draft {
                            Text(timeText(draft)).font(.caption).foregroundStyle(.secondary)
                        }
                        TextField(
                            model.t("Tiêu đề (không bắt buộc)", "Title (optional)"),
                            text: $title,
                            axis: .vertical
                        )
                        .lineLimit(1 ... 3).textFieldStyle(.roundedBorder).accessibilityIdentifier("review.title")
                        .onChange(of: title) { _, value in
                            if value.count > 120 {
                                title = String(value.prefix(120))
                            }
                        }
                        HStack { Spacer(); Text("\(title.count)/120").font(.caption).foregroundStyle(.secondary) }
                        Toggle(
                            model.t("Ẩn vị trí ảnh này", "Hide this photo's location"),
                            isOn: Binding(get: { model.currentHidden }, set: { model.currentHideChanged($0) })
                        )
                        .accessibilityIdentifier("review.hide")
                        Text(model.t(
                            "Chỉ ảnh này. Mặc định cho ảnh mới nằm trong Cài đặt.",
                            "This photo only. The default for new photos is in Settings."
                        ))
                        .font(.footnote).foregroundStyle(.secondary)
                        Divider()
                        placeSection
                        if model.processing {
                            ProgressView(model.t("Đang xử lý ảnh", "Processing image"))
                        }
                        if draft?.state == "processingFailed", let id = model.reviewID {
                            Label(
                                model.t("Đã lưu trên máy – cần xử lý ảnh", "Saved on device – image processing needed"),
                                systemImage: "exclamationmark.circle"
                            ).foregroundStyle(G2Style.coral)
                            HStack {
                                Button(model.t("Thử lại", "Retry")) { model.retry(id) }.buttonStyle(.bordered)
                                    .accessibilityIdentifier("review.retry")
                                Button(model.t("Xóa nháp", "Delete draft"), role: .destructive) { deleting = true }
                                    .buttonStyle(.bordered)
                            }
                        }
                        Label(
                            model
                                .t(
                                    "Chưa đồng bộ · bản thử G2 không có máy chủ",
                                    "Not synced · the G2 prototype has no server"
                                ),
                            systemImage: "icloud.slash"
                        )
                        .font(.footnote).foregroundStyle(.secondary)
                    }.padding(.horizontal, 20)
                }.padding(.bottom, 24)
            }
            .navigationTitle(model.t("Khoảnh khắc", "Moment")).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(model.t("Xong", "Done")) { model.finishReview(title: title) }
                        .accessibilityIdentifier("review.done")
                }
            }
            .onAppear { title = draft?.title ?? "" }
            .sheet(isPresented: $choosing) { PlaceChooser(model: model) { place in choose(place) } }
            .g2ErrorAlert(model, active: !choosing)
            .confirmationDialog(
                model.t("Ảnh cách nơi này hơn 1 km", "Photo is over 1 km from this place"),
                isPresented: Binding(get: { mismatch != nil }, set: {
                    if !$0 {
                        mismatch = nil
                    }
                }),
                titleVisibility: .visible
            ) {
                Button(model.t("Vẫn gắn ", "Attach anyway: ") + (mismatch?.name ?? "")) {
                    model.attach(mismatch?.id); mismatch = nil
                }
                Button(model.t("Lưu không nơi", "Save without a place")) { model.attach(nil); mismatch = nil }
                Button(model.t("Hủy", "Cancel"), role: .cancel) { mismatch = nil }
            } message: { Text(model.t(
                "GPS trong chính ảnh cho thấy ảnh được chụp xa nơi bạn chọn. Không dùng vị trí hiện tại.",
                "The photo's own GPS suggests it was taken far from the place you chose. Current location is not used."
            )) }
            .alert(model.t("Xóa nháp và ảnh gốc trên máy?", "Delete draft and its original?"), isPresented: $deleting) {
                Button(model.t("Hủy", "Cancel"), role: .cancel) {}
                Button(model.t("Xóa", "Delete"), role: .destructive) {
                    if let id = model.reviewID {
                        model.deleteDraft(id)
                    }
                }
            }
        }
    }

    @ViewBuilder private var placeSection: some View {
        if let attached {
            Label(attached.name, systemImage: "mappin.circle.fill").accessibilityIdentifier("review.attached")
            Button(model.t("Bỏ gắn địa điểm", "Remove place")) { model.attach(nil) }.font(.subheadline)
        } else {
            Label(model.t("Chưa gắn địa điểm", "No place attached"), systemImage: "mappin.slash")
        }
        if draft?.origin.hasPrefix("library") == true {
            Label(
                model.sourceHasGPS ? model.t(
                    "Ảnh có GPS riêng · chỉ đọc trên máy",
                    "Photo has its own GPS · read on device only"
                )
                    : model.t(
                        "Ảnh không có GPS đọc được · không thay bằng vị trí hiện tại",
                        "No readable photo GPS · current location is never substituted"
                    ),
                systemImage: model.sourceHasGPS ? "location.circle" : "location.slash"
            ).font(.footnote)
        }
        if model.libraryCheck == .placeWithoutCoordinate && draft?.origin == "library" {
            Text(model.t(
                "Không so được với ảnh thật: địa điểm mẫu không có tọa độ thật.",
                "Not compared with a real photo: fixture places have no real coordinates."
            ))
            .font(.caption).foregroundStyle(.secondary)
        }
        if model.currentHidden {
            Text(model.t(
                "Tắt “Ẩn vị trí ảnh này” để gắn hoặc nhận diện địa điểm.",
                "Turn off “Hide this photo's location” to attach or recognize a place."
            ))
            .font(.footnote).foregroundStyle(.secondary)
        } else {
            HStack {
                Button { choosing = true } label: { Label(
                    model.t("Chọn địa điểm", "Choose a place"),
                    systemImage: "mappin.and.ellipse"
                ) }
                .buttonStyle(.bordered).accessibilityIdentifier("review.choosePlace")
                Button { model.requestLocation(.review) } label: { Label(
                    model.t("Kiểm tra vị trí", "Check location"),
                    systemImage: "location"
                ) }
                .buttonStyle(.bordered).disabled(model.accountID == nil)
            }
            if location
                .result !=
                "idle"
            {
                Text(model.locationText(location.result)).font(.footnote).foregroundStyle(.secondary)
            }
            Text(model.gateText(model.gate)).font(.footnote).foregroundStyle(.secondary)
                .accessibilityIdentifier("review.gate")
            if !model.reviewZone.allowsPlace(hidden: false) {
                Text(model.zoneText(model.reviewZone)).font(.caption).foregroundStyle(.secondary)
                    .accessibilityIdentifier("review.zone")
            }
        }
    }

    private func choose(_ place: PrototypePlace) {
        if case .mismatch = model.checkAttach(place) {
            mismatch = place
        } else {
            model.attach(place.id)
        }
    }

    private func timeText(_ draft: DraftSummary) -> String {
        if let captured = draft.capturedAt {
            return model.t("Chụp lúc ", "Taken ") + captured.formatted(
                date: .abbreviated,
                time: .shortened
            )
        }
        return model.t("Thời điểm thêm ", "Added ") + draft.createdAt.formatted(date: .abbreviated, time: .shortened)
    }
}

/// Manual choice plus the three recognition branches. Fixture only; no coordinate leaves the device.
struct PlaceChooser: View {
    @ObservedObject var model: AppModel
    let chosen: (PrototypePlace) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var outcome: Assignment?
    @State private var blocked = false
    var body: some View {
        NavigationStack {
            List {
                // Choosing by hand never lifts zone protection (addendum §3.2); say why first, where it is visible.
                if !placeAllowed {
                    Label(model.zoneText(model.reviewZone), systemImage: "lock.fill").font(.footnote)
                        .foregroundStyle(.secondary).accessibilityIdentifier("chooser.zone")
                }
                Section {
                    Button(model.t("Thử ngữ cảnh rõ ràng", "Try a strong context")) { evaluate(runnerUp: 0.1) }
                    Button(model.t("Thử nhiều ứng viên", "Try several candidates")) { evaluate(runnerUp: 0.9) }
                    Button(model.t("Thử không có ngữ cảnh", "Try with no context")) {
                        outcome = .unassigned; blocked = false
                    }
                    if blocked {
                        Text(placeAllowed ? model.gateText(model.liveGate ?? .noSample) : model
                            .zoneText(model.reviewZone)).font(.footnote).foregroundStyle(G2Style.coral)
                    }
                    if let outcome {
                        Text(outcomeText(outcome)).font(.footnote).accessibilityIdentifier("chooser.outcome")
                    }
                } header: { Text(model.t(
                    "Nhận diện mẫu · dữ liệu giả, không gọi Google",
                    "Fixture recognition · synthetic, no Google call"
                )) }
                Section {
                    ForEach(outcome == .confirm ? Array(PrototypePlace.fixtures.prefix(2)) : PrototypePlace
                        .fixtures)
                    { place in
                        Button { chosen(place); dismiss() } label: { PlaceRow(place: place, english: model.english)
                        }
                        .buttonStyle(.plain).accessibilityIdentifier("chooser." + place.id)
                    }
                    .disabled(!placeAllowed)
                } header: { Text(model.t("Chọn thủ công", "Choose yourself")) }
                Button(model.t("Lưu không nơi", "Keep without a place")) { model.attach(nil); dismiss() }
            }
            .navigationTitle(model.t("Địa điểm", "Place")).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button(model.t("Đóng", "Close")) { dismiss() }.accessibilityIdentifier("chooser.close")
            } }
        }.presentationDetents([.medium, .large])
    }

    private var placeAllowed: Bool {
        model.reviewZone.allowsPlace(hidden: model.currentHidden)
    }

    private func evaluate(runnerUp: Double) {
        // Only a fresh sample that passed the gate (via Check location or a Lab sample) may reach recognition,
        // and only for a photo that no zone blocks.
        guard model.liveGate == .allowed, placeAllowed else { blocked = true; outcome = nil; return }
        blocked = false
        let calibration = Calibration(auto: 0.95, confirm: 0.6, contextTTL: 20, version: "fixture-only")
        outcome = AssignmentPolicy.decide(score: 0.99, runnerUp: runnerUp, calibration: calibration)
        if outcome == .automatic {
            chosen(PrototypePlace.fixtures[0]); dismiss()
        }
    }

    private func outcomeText(_ value: Assignment) -> String {
        switch value {
        case .automatic: return model.t("Tự gắn · chỉ minh họa", "Automatic · illustration only")
        case .confirm: return model.t(
                "Cần xác nhận: chọn một trong các nơi dưới đây",
                "Confirmation needed: choose one below"
            )
        case .unassigned: return model.t(
                "Không có ngữ cảnh: lưu không nơi hoặc tự chọn",
                "No context: save without a place or choose yourself"
            )
        }
    }
}
