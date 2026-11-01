import G2Core
import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var model: AppModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label(
                        model.accountID
                            .map { $0.hasSuffix("a") ? model.t("Tài khoản mẫu A", "Fixture account A") : model.t(
                                "Tài khoản mẫu B",
                                "Fixture account B"
                            ) } ?? model.t("Chưa đăng nhập", "Signed out"),
                        systemImage: "person.crop.circle.fill"
                    )
                    .font(.headline)
                    Text(model.t("G2 · Tài khoản giả trên máy này", "G2 · Synthetic account on this device"))
                        .font(.caption).foregroundStyle(.secondary)
                    if model.accountID == nil {
                        Button(model.t("Tiếp tục với tài khoản mẫu A", "Continue with fixture account A")) {
                            model.login()
                        }.accessibilityIdentifier("fixture.login")
                    }
                }
                Section {
                    NavigationLink { JournalScreen(model: model) } label: { Label(
                        model.t("Khoảnh khắc của tôi", "My moments"),
                        systemImage: "photo.stack"
                    ) }
                    .accessibilityIdentifier("profile.moments")
                    NavigationLink { SavedScreen(model: model) } label: { Label(
                        model.t("Nơi đã lưu", "Saved places"),
                        systemImage: "bookmark"
                    ) }
                    NavigationLink { PendingScreen(model: model) } label: { Label(
                        model.t("Liên kết đang chờ", "Pending links") + " (\(model.pending.count))",
                        systemImage: "tray"
                    ) }
                    .accessibilityIdentifier("profile.pending")
                    NavigationLink { PrivacySettings(model: model) } label: { Label(
                        model.t("Cài đặt", "Settings"),
                        systemImage: "gearshape"
                    ) }
                    .accessibilityIdentifier("profile.settings")
                }
                Section("G2 Lab") {
                    NavigationLink { LabScreen(model: model) } label: { Label(
                        model.t("Thử kỹ thuật", "Technical probes"),
                        systemImage: "testtube.2"
                    ) }
                    .accessibilityIdentifier("profile.lab")
                    Text(model.t("Google live khóa · Không chi tiêu", "Google live locked · No spending"))
                        .font(.caption).foregroundStyle(.secondary)
                }
                if model.accountID != nil {
                    Section {
                        Button(model
                            .t("Đổi sang tài khoản mẫu ", "Switch to fixture account ") +
                            (model.accountID?.hasSuffix("a") == true ? "B" : "A"))
                        {
                            model.login(model.accountID?.hasSuffix("a") == true ? "b" : "a")
                        }
                        Button(model.t("Đăng xuất tài khoản mẫu", "Sign out fixture account"), role: .destructive) {
                            model.logout()
                        }
                    }
                }
            }.navigationTitle(model.t("Hồ sơ", "Profile")).navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) { Button(model.t("Xong", "Done")) { dismiss() } }
                }
        }.tint(G2Style.green).g2ErrorAlert(model, active: true)
    }
}

struct JournalScreen: View {
    @ObservedObject var model: AppModel
    @Environment(\.dismiss) private var dismiss
    @State private var deleting: UUID?
    private var days: [Date] {
        Set(model.drafts.map { Calendar.current.startOfDay(for: $0.createdAt) }).sorted(by: >)
    }

    var body: some View {
        List {
            if model.drafts.isEmpty {
                ContentUnavailableView(model.t("Chưa có khoảnh khắc", "No moments yet"), systemImage: "photo.stack")
            }
            ForEach(days, id: \.self) { day in
                Section(day.formatted(date: .abbreviated, time: .omitted)) {
                    ForEach(model.drafts.filter { Calendar.current.isDate($0.createdAt, inSameDayAs: day) }) { draft in
                        Button {
                            dismiss()
                            Task {
                                try? await Task.sleep(nanoseconds: 400_000_000); model.profile = false; try? await Task
                                    .sleep(nanoseconds: 400_000_000); model.openDraft(draft)
                            }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                if let path = model.store?.imageURL(draft.id, thumbnail: true).path,
                                   let image = UIImage(contentsOfFile: path)
                                {
                                    Image(uiImage: image).resizable().scaledToFill().frame(width: 72, height: 72)
                                        .clipped()
                                } else {
                                    Image(systemName: "photo.badge.exclamationmark").frame(width: 72, height: 72)
                                        .background(Color(.secondarySystemBackground))
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(draft.title.isEmpty ? model.t("Khoảnh khắc", "Moment") : draft.title)
                                        .font(.subheadline.weight(.medium))
                                    Text(draft.capturedAt.map { model.t("Chụp ", "Taken ") + $0.formatted(
                                        date: .omitted,
                                        time: .shortened
                                    ) }
                                        ?? model.t("Thêm ", "Added ") + draft.createdAt.formatted(
                                            date: .omitted,
                                            time: .shortened
                                        )).font(.caption).foregroundStyle(.secondary)
                                    Text(model.t("Đã lưu trên máy · chưa đồng bộ", "Saved on device · not synced"))
                                        .font(.caption).foregroundStyle(G2Style.green)
                                        .accessibilityIdentifier("state.local")
                                    Label(
                                        placeText(draft),
                                        systemImage: draft.hidden ? "location.slash" : draft
                                            .placeID == nil ? "mappin.slash" : "mappin.circle"
                                    ).font(.caption).foregroundStyle(.secondary)
                                    if draft.state == "processingFailed" {
                                        Text(model.t(
                                            "Cần xử lý ảnh",
                                            "Processing needed"
                                        )).font(.caption).foregroundStyle(G2Style.coral)
                                    }
                                }
                                Spacer(minLength: 0)
                            }.foregroundStyle(.primary)
                        }.buttonStyle(.plain)
                            .swipeActions { Button(role: .destructive) { deleting = draft.id } label: { Label(
                                model.t("Xóa", "Delete"),
                                systemImage: "trash"
                            ) } }
                    }
                }
            }
        }.navigationTitle(model.t("Nhật ký của tôi", "My journal")).navigationBarTitleDisplayMode(.inline)
            .alert(
                model.t("Xóa ảnh trên máy?", "Delete local photo?"),
                isPresented: Binding(get: { deleting != nil }, set: {
                    if !$0 {
                        deleting = nil
                    }
                })
            ) {
                Button(model.t("Hủy", "Cancel"), role: .cancel) { deleting = nil }
                Button(model.t("Xóa", "Delete"), role: .destructive) {
                    if let id = deleting {
                        model.deleteDraft(id)
                    }; deleting = nil
                }
            } message: { Text(model.t(
                "G2 chưa có bản đồng bộ. Ảnh gốc và bản xử lý sẽ bị xóa.",
                "G2 has no synced copy. Original and processed files will be deleted."
            )) }
    }

    private func placeText(_ draft: DraftSummary) -> String {
        if draft.hidden {
            return model.t("Vị trí ẩn", "Location hidden")
        }
        return PrototypePlace.fixture(draft.placeID)?.name ?? model.t("Chưa gắn địa điểm", "No place attached")
    }
}

struct PendingScreen: View {
    @ObservedObject var model: AppModel
    @State private var link = ""
    @State private var resolving: InboxItem?
    var body: some View {
        List {
            Section {
                TextField(model.t("Dán liên kết HTTPS", "Paste an HTTPS link"), text: $link)
                    .textInputAutocapitalization(.never).autocorrectionDisabled().keyboardType(.URL)
                    .accessibilityIdentifier("pending.url")
                    .onChange(of: link) {
                        _, value in if !value.isEmpty {
                            model.notice = nil
                        }
                    }
                // Inline, non-modal confirmation: a root alert would sit under this sheet and dismiss it.
                if let notice = model.notice {
                    Label(
                        notice,
                        systemImage: model.noticeIsError ? "exclamationmark.circle.fill" : "checkmark.circle.fill"
                    )
                    .foregroundStyle(model.noticeIsError ? G2Style.coral : G2Style.green)
                    .accessibilityIdentifier("pending.notice")
                }
                Button {
                    if model.addLink(link) {
                        link = ""
                    }
                } label: { Label(
                    model.t("Lưu liên kết", "Save link"),
                    systemImage: "plus"
                ) }
                .disabled(model.accountID == nil || link.isEmpty).accessibilityIdentifier("pending.save")
                Text(model.t(
                    "Liên kết được giữ ở trạng thái PENDING tới khi bạn chọn địa điểm. Không đọc nội dung trang.",
                    "Links stay PENDING until you choose a place. Page content is not read."
                ))
                .font(.caption).foregroundStyle(.secondary)
            }
            if model.accountID == nil {
                Section { Label(
                    model
                        .t(
                            "Đăng nhập để lưu liên kết; không lưu dữ liệu vô chủ.",
                            "Sign in to save links; nothing is stored without an owner."
                        ),
                    systemImage: "person.crop.circle.badge.exclamationmark"
                ) }
            }
            if !model.sharedAvailable {
                Section { Label(
                    model
                        .t(
                            "App Group chưa khả dụng; Share Extension cần signing đúng.",
                            "App Group unavailable; Share Extension needs provisioned signing."
                        ),
                    systemImage: "exclamationmark.triangle"
                ).font(.footnote) }
            }
            ForEach(model.pending) { item in
                VStack(alignment: .leading, spacing: 7) {
                    Label(URL(string: item.canonicalURL)?.host ?? "Link", systemImage: "link")
                        .accessibilityIdentifier("pending.item")
                    Text("PENDING · " + model.t("chưa xác định địa điểm", "place not identified"))
                        .font(.caption.monospaced()).foregroundStyle(G2Style.coral)
                    Text(item.receivedAt.formatted()).font(.caption).foregroundStyle(.secondary)
                    if let types = item.receivedTypes,
                       !types
                           .isEmpty
                    {
                        Text(types.joined(separator: ", ")).font(.caption2.monospaced()).foregroundStyle(.secondary)
                    }
                    Button(model.t("Chọn địa điểm cho liên kết", "Choose a place for this link")) { resolving = item }
                        .font(.subheadline).accessibilityIdentifier("pending.resolve")
                }.swipeActions { Button(role: .destructive) { model.deleteLink(item) } label: { Label(
                    model.t("Xóa", "Delete"),
                    systemImage: "trash"
                ) } }
            }
        }.navigationTitle(model.t("Chờ xử lý", "Pending")).navigationBarTitleDisplayMode(.inline)
            .onDisappear { model.notice = nil }
            .sheet(item: $resolving) { item in
                NavigationStack {
                    List(PrototypePlace.fixtures) { place in
                        Button { model.resolveLink(item, with: place); resolving = nil } label: { PlaceRow(
                            place: place,
                            english: model.english
                        ) }
                        .buttonStyle(.plain).accessibilityIdentifier("resolve." + place.id)
                    }
                    .navigationTitle(model.t("Lưu thành Muốn ghé", "Save as Want to visit"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(model.t("Đóng", "Close")) { resolving = nil }
                        }
                    }
                }.presentationDetents([.medium, .large])
            }
    }
}

struct PrivacySettings: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var location: LocationEngine
    @State private var disabling = false
    init(model: AppModel) {
        self.model = model; location = model.location
    }

    var body: some View {
        Form {
            Section(model.t("Ngôn ngữ", "Language")) {
                Picker(model.t("Ngôn ngữ", "Language"), selection: $model.english) {
                    Text("Tiếng Việt").tag(false); Text("English").tag(true)
                }.pickerStyle(.segmented)
            }
            Section {
                Toggle(
                    model.t("Ẩn vị trí cho ảnh mới", "Hide location for new photos"),
                    isOn: Binding(get: { model.policy.hide }, set: { value in model.changePolicy { $0.hide = value } })
                )
                .accessibilityIdentifier("settings.hideDefault")
                Text(model.t(
                    "Không đổi ảnh cũ. Tất cả ảnh vẫn riêng tư.",
                    "Existing photos stay unchanged. All photos remain private."
                )).font(.footnote).foregroundStyle(.secondary)
            }
            Section {
                Toggle(
                    model.t("Ẩn trong vùng riêng tư", "Hide in private zones"),
                    isOn: Binding(get: { model.policy.zoneProtection }, set: { value in
                        if value {
                            model.changePolicy { $0.zoneProtection = true }
                        } else {
                            disabling = true
                        }
                    })
                ).accessibilityIdentifier("settings.zoneProtection")
                ForEach(model.policy.zones) { zone in
                    NavigationLink { ZoneEditor(model: model, zoneID: zone.id) } label: {
                        HStack { Label(
                            zone.name.isEmpty ? model.t("Vùng riêng tư", "Private zone") : zone.name,
                            systemImage: "house.circle"
                        ); Spacer(); Text("\(Int(zone.radius)) m").font(.subheadline).foregroundStyle(.secondary) }
                    }
                }.onDelete { offsets in model.changePolicy { policy in policy.zones.remove(atOffsets: offsets) } }
                Button { model.addZoneAtCurrentLocation() } label: { Label(
                    model.t("Thêm vùng tại vị trí hiện tại", "Add a zone at my current location"),
                    systemImage: "plus.circle"
                ) }
                .accessibilityIdentifier("settings.addZone")
                if location
                    .result !=
                    "idle"
                {
                    Text(model.locationText(location.result)).font(.caption).foregroundStyle(.secondary)
                }
                if !model.policy.zonesVerified {
                    Button(model.t("Xác nhận danh sách vùng hiện tại", "Confirm current zone list")) {
                        model.changePolicy { $0.zonesVerified = true }
                    }
                    Text(model.t(
                        "Chưa xác minh vùng: nhận diện ngoài máy bị chặn khi bảo vệ bật.",
                        "Zones not verified: external recognition blocked while protection is on."
                    )).font(.footnote).foregroundStyle(.secondary)
                }
                Text(model.t(
                    "Vùng chỉ ở máy này, tách theo tài khoản, không sao lưu đám mây. Mất máy có thể mất vùng.",
                    "Zones stay on this device, per account, with no cloud backup. Device loss may lose zones."
                )).font(.footnote).foregroundStyle(.secondary)
            } header: { Text(model.t("Vùng riêng tư", "Private zones")) }
            Section {
                Toggle(
                    model.t("Cho phép nhận diện bên ngoài", "Allow external recognition"),
                    isOn: Binding(
                        get: { model.policy.externalConsent },
                        set: { value in model.changePolicy { $0.externalConsent = value } }
                    )
                )
                .accessibilityIdentifier("settings.consent")
                Text(model.t(
                    "Quyền riêng với GPS. Khi live được duyệt, thao tác nhận diện chủ động có thể gửi vị trí đủ điều kiện "
                        + "cho Google. Hide và vùng bảo vệ vẫn có hiệu lực. G2 hiện khóa mọi cuộc gọi live.",
                    "Separate from GPS access. Once live is authorized, explicit recognition may send eligible location "
                        + "to Google. Hide and zones still apply. G2 currently locks all live calls."
                ))
                .font(.footnote).foregroundStyle(.secondary)
                Text(model.t(
                    "Đổi quyền hủy ngữ cảnh đang chờ; không phát lại tác vụ cũ.",
                    "Permission changes invalidate pending context; old jobs are not replayed."
                )).font(.footnote).foregroundStyle(.secondary)
            } header: { Text(model.t("Đồng ý nhận diện bên ngoài", "External recognition consent")) }
        }.disabled(model.accountID == nil).navigationTitle(model.t("Cài đặt", "Settings"))
            .navigationBarTitleDisplayMode(.inline)
            // An alert keeps an explicit Cancel; newer iOS turns confirmation dialogs into popovers without one.
            .alert(model.t("Tắt bảo vệ vùng?", "Turn off zone protection?"), isPresented: $disabling) {
                Button(model.t("Tắt bảo vệ vùng", "Turn off zone protection"), role: .destructive) {
                    model.changePolicy { $0.zoneProtection = false }
                }
                Button(model.t("Hủy", "Cancel"), role: .cancel) {}
            } message: { Text(model.t(
                "Không tắt Ẩn vị trí, không cấp đồng ý nhận diện, không hiện lại vị trí ảnh cũ hoặc phát lại hàng chờ.",
                "Does not turn off Hide location, grant recognition consent, reveal old photo locations or replay pending jobs."
            )) }
    }
}

struct ZoneEditor: View {
    @ObservedObject var model: AppModel
    let zoneID: UUID
    @State private var name = ""
    @State private var radius = 200.0
    @State private var loaded = false
    var body: some View {
        Form {
            TextField(model.t("Tên vùng", "Zone name"), text: $name)
            LabeledContent(model.t("Bán kính", "Radius"), value: "\(Int(radius)) m")
            Slider(value: $radius, in: 100 ... 1000, step: 50).accessibilityLabel(model.t(
                "Bán kính vùng",
                "Zone radius"
            ))
            Button(model.t("Lưu thay đổi", "Save changes")) {
                model.changePolicy { policy in
                    if let index = policy.zones.firstIndex(where: { $0.id == zoneID }) {
                        policy.zones[index].name = String(name.prefix(80)); policy.zones[index].radius = radius
                    }
                }
            }
            Text(model.t(
                "Tâm vùng không hiển thị trong nhật ký hay bằng chứng thử.",
                "Zone centers are not shown in logs or test evidence."
            )).font(.footnote).foregroundStyle(.secondary)
        }.navigationTitle(model.t("Vùng riêng tư", "Private zone")).navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if !loaded,
                   let zone = model.policy.zones
                       .first(where: { $0.id == zoneID })
                {
                    name = zone.name; radius = zone.radius; loaded = true
                }
            }
    }
}

struct LabScreen: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var lab: PlacesLab
    @ObservedObject private var location: LocationEngine
    @State private var placeID = ""
    @State private var label = ""
    @State private var linkError = false
    init(model: AppModel) {
        self.model = model; lab = model.places; location = model.location
    }

    var body: some View {
        Form {
            Section("G2 · FIXTURE") {
                Picker(model.t("Tình huống", "Scenario"), selection: $lab.scenario) {
                    ForEach(LabScenario.allCases) { Text($0.title(model.english)).tag($0) }
                }.accessibilityIdentifier("lab.scenario")
                Text(model.t(
                    "Tình huống giả, không chứng minh API hoặc thực địa.",
                    "Synthetic scenarios are not API or field evidence."
                )).font(.footnote).foregroundStyle(.secondary)
            }
            Section(model.t(
                "Privacy canary · tọa độ giả quanh 0,0",
                "Privacy canary · synthetic coordinates near 0,0"
            )) {
                Button(model.t("Thêm vùng canary 0,0 (200 m)", "Add canary zone at 0,0 (200 m)")) {
                    model.changePolicy { $0.zones.append(.init(
                        name: "Canary",
                        center: .init(latitude: 0, longitude: 0)
                    )); $0.zonesVerified = true }
                }.disabled(model.accountID == nil).accessibilityIdentifier("lab.canaryZone")
                ForEach(SyntheticSample.allCases) { kind in
                    Button(sampleTitle(kind)) { model.inject(kind) }.disabled(model.accountID == nil)
                        .accessibilityIdentifier("lab.sample." + kind.rawValue)
                }
                if location.result != "idle" {
                    Text(model.locationText(location.result)).font(.caption)
                }
                Text(model.gateText(model.gate)).font(.caption).accessibilityIdentifier("lab.gate")
                Text(model.t(
                    "Chỉ tọa độ giả, mẫu bị hủy ngay sau đánh giá. Không thay vùng thật hoặc tắt bảo vệ để tăng coverage.",
                    "Synthetic coordinates only; each sample is discarded right after evaluation. Do not replace real zones or disable protection to inflate coverage."
                ))
                .font(.footnote).foregroundStyle(.secondary)
            }
            Section(model.t("Ảnh thư viện mẫu · B3", "Fixture library photo · B3")) {
                Button(model.t("Ảnh có GPS giả gần Test Garden", "Photo with synthetic GPS near Test Garden")) {
                    libraryFixture(.init(
                        latitude: 0.0105,
                        longitude: 0
                    ))
                }
                .accessibilityIdentifier("lab.library.near")
                Button(model.t(
                    "Ảnh có GPS giả cách Test Garden ~2,2 km",
                    "Photo with synthetic GPS ~2.2 km from Test Garden"
                )) { libraryFixture(.init(latitude: 0.03, longitude: 0)) }
                    .accessibilityIdentifier("lab.library.far")
                Button(model.t("Ảnh không có GPS", "Photo without GPS")) { libraryFixture(nil) }
                    .accessibilityIdentifier("lab.library.none")
            }.disabled(model.accountID == nil)
            Section(model.t("Trace ứng dụng · QP-02", "Application trace · QP-02")) {
                LabeledContent(
                    model.t("Sự kiện thụ động (mở Map, pan, zoom)", "Passive events (Map open, pan, zoom)"),
                    value: "\(lab.passiveEvents)"
                )
                LabeledContent(model.t("Request do sự kiện thụ động", "Requests from passive events"), value: "0")
                LabeledContent(
                    model.t("Lệnh chủ động (fixture)", "Explicit fixture commands"),
                    value: "\(lab.explicitRequests)"
                ).accessibilityIdentifier("lab.explicit")
                LabeledContent("Places live", value: "0 · LOCKED")
                LabeledContent(
                    "Maps SDK",
                    value: model.t("Chưa khởi tạo · đo riêng", "Not initialized · separate trace")
                )
                ForEach(Array(lab.trace.enumerated()), id: \.offset) { Text($0.element).font(.caption.monospaced()) }
            }
            Section(model.t("Đo sơ bộ trong bộ nhớ", "Preliminary in-memory timings")) {
                LabeledContent(
                    model.t("Chụp → nháp bền vững (ms)", "Capture → durable draft (ms)"),
                    value: summary(model.captureDurableMs)
                )
                LabeledContent(
                    model.t("Bật camera → preview (ms)", "Camera start → preview (ms)"),
                    value: summary(model.cameraReadyMs)
                )
                Text(model.t(
                    "Không phải Q-01/Q-03: chưa đo từ biểu tượng app, chưa đủ mẫu và thiết bị đã duyệt.",
                    "Not Q-01/Q-03: not measured from the app icon, without the sample size or approved devices."
                ))
                .font(.footnote).foregroundStyle(.secondary)
            }
            Section(model.t("Mở Google Maps · máy thật", "Open Google Maps · real device")) {
                TextField("Google Place ID", text: $placeID).textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField(model.t("Tên đích do bạn nhập", "Destination label you enter"), text: $label)
                Button {
                    guard !placeID.hasPrefix("fixture"), let url = MapLinks.directions(
                        placeID: placeID.trimmingCharacters(in: .whitespacesAndNewlines),
                        label: label
                    ) else { linkError = true; return }
                    UIApplication.shared.open(url)
                } label: { Label(model.t("Mở Google Maps", "Open Google Maps"), systemImage: "arrow.up.right.square") }
                    .disabled(placeID.isEmpty)
                Text(model.t(
                    "Maps URL không cần khóa và không gửi origin. Ứng dụng/website Google dùng mạng và quyền riêng của nó.",
                    "Maps URLs need no key and send no origin. The Google app/website uses its own network and permissions."
                ))
                .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Google Maps SDK 11.2.0") {
                LiveGoogleMapProbe().frame(height: PlacesLab.liveAuthorized ? 220 : 0)
                Label(
                    model.t(
                        "Khóa: chưa có khóa riêng, trần thử và phê duyệt live. Không khởi tạo SDK.",
                        "Locked: no private key, smoke budget or live approval. SDK not initialized."
                    ),
                    systemImage: "lock"
                )
                .font(.footnote)
            }
            Section(model.t("Cổng còn thiếu", "Missing gates")) {
                Text(model.t(
                    "iPhone thật, signing/App Group, quota và trần thử được duyệt, proxy an toàn, LEGAL và 5 người thử thật.",
                    "Physical iPhone, signing/App Group, approved quota and smoke budget, safe proxy, LEGAL and 5 real participants."
                ))
                Text("G2: IN_PROGRESS").font(.caption.monospaced())
            }
        }.navigationTitle("G2 Lab").navigationBarTitleDisplayMode(.inline)
            .alert(model.t("Place ID không hợp lệ", "Invalid Place ID"), isPresented: $linkError) { Button("OK") {} }
    }

    private func sampleTitle(_ kind: SyntheticSample) -> String {
        switch kind {
        case .outside: return model.t("Mẫu giả: ngoài vùng ~1,1 km, ±10 m", "Synthetic: outside ~1.1 km, ±10 m")
        case .inside: return model.t("Mẫu giả: tại tâm vùng canary", "Synthetic: at the canary zone center")
        case .edge: return model.t(
                "Mẫu giả: ngoài 200 m nhưng vòng sai số chạm vùng",
                "Synthetic: outside 200 m but error circle touches zone"
            )
        case .approximate: return model.t("Mẫu giả: vị trí gần đúng", "Synthetic: approximate location")
        case .stale: return model.t("Mẫu giả: cũ 90 giây", "Synthetic: 90 seconds old")
        }
    }

    private func libraryFixture(_ gps: Coordinate?) {
        model.profile = false
        Task { try? await Task.sleep(nanoseconds: 700_000_000); model.capture(
            AppModel.fixtureImage(gps: gps),
            origin: "library-fixture"
        ) }
    }

    private func summary(_ values: [Double]) -> String {
        guard !values.isEmpty else { return "—" }
        let sorted = values.sorted()
        return String(format: "n=%d · max %.0f · last %.0f", values.count, sorted.last!, values.last!)
    }
}
