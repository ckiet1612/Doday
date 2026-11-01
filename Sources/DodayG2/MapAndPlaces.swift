import G2Core
import SwiftUI

struct MapScreen: View {
    @ObservedObject var model: AppModel
    @ObservedObject private var lab: PlacesLab
    @ObservedObject private var location: LocationEngine
    @State private var query = ""
    @State private var results: [PrototypePlace] = []
    @State private var selected: PrototypePlace?
    @State private var showSaved = false
    @State private var showPending = false
    @State private var searching = false
    @State private var message: String?
    @State private var searchTask: Task<Void, Never>?
    @State private var expanded = false
    @FocusState private var searchFocused: Bool
    init(model: AppModel) {
        self.model = model; lab = model.places; location = model.location
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField(model.t("Tìm tên hoặc khu vực", "Search a name or area"), text: $query)
                    .submitLabel(.search).focused($searchFocused).accessibilityIdentifier("map.search").onSubmit { search() }
                if !query.isEmpty {
                    Button { query = ""; searchTask?.cancel(); results = []; message = nil } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .accessibilityLabel(model.t("Xóa tìm kiếm", "Clear search"))
                }
                Button { search() } label: { Image(systemName: "arrow.right.circle.fill").font(.title2).frame(
                    width: 44,
                    height: 44
                ) }
                .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).count < TriggerPolicy
                    .minimumQueryLength)
                .accessibilityLabel(model.t("Tìm", "Search")).accessibilityIdentifier("search.submit")
            }.padding(.horizontal, 16).padding(.vertical, 8).background(Color(.secondarySystemBackground))
            if lab.scenario == .offline {
                Label(
                    model.t(
                        "Đang offline. Bản đồ nền có thể không hiện và không có tải bản đồ offline; nơi đã lưu vẫn ở danh sách.",
                        "Offline. The base map may not appear and offline maps are not offered; saved places stay in your list."
                    ),
                    systemImage: "wifi.slash"
                ).font(.footnote).padding(.horizontal, 16).padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading).background(G2Style.coral.opacity(0.12))
            }
            ZStack(alignment: .bottom) {
                FixtureMap(
                    places: visibleMarkers,
                    saved: model.saved,
                    english: model.english,
                    selected: { selected = $0 },
                    passive: { lab.passive($0) }
                )
                HStack(spacing: 10) {
                    mapButton(model.t("Gần tôi", "Near me"), icon: "location", id: "map.nearby") {
                        model.requestLocation(.nearby)
                    }
                    Spacer()
                    mapButton(
                        model.t("Chờ", "Pending") + (model.pending.isEmpty ? "" : " \(model.pending.count)"),
                        icon: "tray",
                        id: "map.pending"
                    ) { showPending = true }
                    mapButton(model.t("Đã lưu", "Saved"), icon: "bookmark.fill", id: "map.saved") { showSaved = true }
                }.padding(12)
            }.frame(maxHeight: .infinity).frame(minHeight: 150)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(listTitle).font(.headline)
                    Spacer()
                    Button { expanded.toggle() } label: {
                        Image(systemName: expanded ? "chevron.down" : "chevron.up").frame(
                            width: 44,
                            height: 44
                        )
                    }
                    .accessibilityLabel(expanded ? model.t("Thu gọn danh sách", "Collapse places") : model.t(
                        "Mở rộng danh sách",
                        "Expand places"
                    ))
                }
                if searching {
                    ProgressView(model.t("Đang tìm", "Searching"))
                } else if let message {
                    Label(message, systemImage: "exclamationmark.circle").font(.subheadline)
                        .foregroundStyle(.secondary)
                } else if let blocked = model.nearbyBlocked {
                    Label(
                        nearbyBlockedText(blocked),
                        systemImage: "location.slash"
                    ).font(.subheadline).foregroundStyle(.secondary)
                } else if location.result == "denied" || location.result == "restricted" {
                    Label(
                        model.t(
                            "“Gần tôi” cần quyền vị trí. Tìm theo tên hoặc khu vực vẫn dùng được.",
                            "“Near me” needs location access. Searching by name or area still works."
                        ),
                        systemImage: "location.slash"
                    ).font(.subheadline).foregroundStyle(.secondary)
                } else if shown.isEmpty {
                    Text(model.saved.isEmpty ? model.t(
                        "Tìm một nơi để lưu. Không cần chụp ảnh trước.",
                        "Search for a place to save. No photo needed first."
                    )
                        : model.t(
                            "Chưa có kết quả mới. Nơi đã lưu ở nút Đã lưu.",
                            "No new results. Saved places are under Saved."
                        ))
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(shown) { place in
                            Button { selected = place } label: {
                                PlaceRow(
                                    place: place,
                                    english: model.english,
                                    intent: model.saved.first { $0.placeID == place.id }
                                ).padding(.vertical, 10).contentShape(Rectangle())
                            }.buttonStyle(.plain).accessibilityIdentifier("place." + place.id)
                            Divider()
                        }
                    }
                }.frame(maxHeight: expanded ? 320 : 138)
                Text(model.t(
                    "Sơ đồ và địa điểm mẫu · Google live khóa",
                    "Synthetic diagram & places · Google live locked"
                ))
                .font(.caption).foregroundStyle(.secondary)
            }.padding(.horizontal, 20).padding(.bottom, 10).background(.background)
        }
        .sheet(item: $selected) { place in PlaceDetail(model: model, place: place) }
        .sheet(isPresented: $showSaved) {
            NavigationStack {
                SavedScreen(model: model).toolbar { ToolbarItem(placement: .confirmationAction) { Button(model.t(
                    "Xong",
                    "Done"
                )) { showSaved = false } } }
            }
        }
        .sheet(isPresented: $showPending) {
            NavigationStack {
                PendingScreen(model: model).toolbar { ToolbarItem(placement: .confirmationAction) { Button(model.t(
                    "Xong",
                    "Done"
                )) { showPending = false } } }
            }
        }
        .onAppear { lab.passive(.mapOpen) }
        .onDisappear { searchTask?.cancel() }
    }

    private var shown: [PrototypePlace] {
        results.isEmpty ? (model.nearbyResults ?? []) : results
    }

    private var listTitle: String {
        if !results.isEmpty {
            return model.t("Kết quả tìm kiếm", "Search results")
        }
        if model.nearbyResults != nil {
            return model.t("Gần bạn · mẫu", "Near you · fixture")
        }
        return model.t("Địa điểm", "Places")
    }

    private func mapButton(_ title: String, icon: String, id: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon).font(.subheadline.weight(.medium)).padding(.horizontal, 12)
                .frame(minHeight: 44)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        }.accessibilityIdentifier(id)
    }

    private func nearbyBlockedText(_ result: GateResult) -> String {
        model.t("“Gần tôi” không gửi vị trí: ", "“Near me” sent no location: ") + model.gateText(result)
            + model.t(" Hãy tìm theo tên hoặc khu vực.", " Search by name or area instead.")
    }

    private var visibleMarkers: [PrototypePlace] {
        guard lab.scenario != .expired else { return [] }
        // Only places with a usable synthetic coordinate get a marker; nothing is guessed or re-fetched for the
        // viewport.
        return PrototypePlace.fixtures
            .filter { place in shown.contains(place) || model.saved.contains { $0.placeID == place.id } }
    }

    private func search() {
        // Results sit under the keyboard otherwise.
        searchFocused = false
        searchTask?.cancel(); results = []; message = nil
        guard query.trimmingCharacters(in: .whitespacesAndNewlines).count >= TriggerPolicy.minimumQueryLength
        else { searching = false; return }
        searching = true
        searchTask = Task {
            do {
                let found = try await lab.search(query)
                guard !Task.isCancelled else { return }
                results = found; searching = false
                if found.isEmpty {
                    message = model.t("Không có địa điểm phù hợp", "No matching places")
                }
            } catch is CancellationError {}
            catch { searching = false; message = model.unavailableText }
        }
    }
}

struct FixtureMap: View {
    let places: [PrototypePlace]
    let saved: [SavedIntent]
    let english: Bool
    let selected: (PrototypePlace) -> Void
    let passive: (APITrigger) -> Void
    @State private var offset: CGSize = .zero
    @State private var zoom: CGFloat = 1
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Canvas { context, size in
                    context.fill(
                        Path(CGRect(origin: .zero, size: size)),
                        with: .color(Color(.secondarySystemBackground))
                    )
                    for fraction in [0.15, 0.5, 0.82] {
                        let park = CGRect(
                            x: size.width * fraction - 34,
                            y: size.height * fraction - 26,
                            width: 68,
                            height: 52
                        )
                        context.fill(Path(roundedRect: park, cornerRadius: 6), with: .color(G2Style.green.opacity(0.1)))
                    }
                    for index in 0 ... 8 {
                        var path = Path()
                        let column = CGFloat(index) * 66 * zoom + offset.width.truncatingRemainder(dividingBy: 66)
                        path.move(to: CGPoint(x: column, y: 0)); path.addLine(to: CGPoint(x: column, y: size.height))
                        context.stroke(path, with: .color(Color(.separator).opacity(0.4)), lineWidth: 7)
                        var horizontal = Path()
                        let row = CGFloat(index) * 74 * zoom + offset.height.truncatingRemainder(dividingBy: 74)
                        horizontal.move(to: CGPoint(x: 0, y: row))
                        horizontal.addLine(to: CGPoint(x: size.width, y: row))
                        context.stroke(horizontal, with: .color(Color(.separator).opacity(0.4)), lineWidth: 7)
                    }
                }
                ForEach(places) { place in
                    let intent = saved.first { $0.placeID == place.id }
                    Button { selected(place) } label: {
                        Image(systemName: intent?
                            .visited == true ? "checkmark.circle.fill" : intent != nil ? "bookmark.circle.fill" :
                            "mappin.circle.fill")
                            .font(.system(size: 34)).symbolRenderingMode(.palette)
                            .foregroundStyle(.white, intent == nil ? Color.secondary : G2Style.green)
                            .frame(width: 48, height: 48)
                    }.position(
                        x: max(
                            24,
                            min(geometry.size.width - 24, geometry.size.width * place.point.x + offset.width / 4)
                        ),
                        y: max(
                            24,
                            min(geometry.size.height - 24, geometry.size.height * place.point.y + offset.height / 4)
                        )
                    )
                    .accessibilityLabel(place.name + ", " + markerLabel(intent))
                    .accessibilityIdentifier("marker." + place.id)
                }
                VStack {
                    HStack {
                        Label("FIXTURE", systemImage: "square.dashed").font(.caption.weight(.bold)).padding(8)
                            .background(.regularMaterial); Spacer()
                    }; Spacer()
                }.padding(12)
            }.clipped()
                .gesture(DragGesture().onChanged { offset = $0.translation }.onEnded { _ in passive(.pan) })
                .simultaneousGesture(
                    MagnifyGesture().onChanged { zoom = min(2, max(1, $0.magnification)) }.onEnded { _ in
                        passive(.zoom)
                    }
                )
                .accessibilityElement(children: .contain)
                .accessibilityLabel(english ? "Doday synthetic place diagram" : "Sơ đồ địa điểm mẫu Doday")
        }
    }

    private func markerLabel(_ intent: SavedIntent?) -> String {
        guard let intent else { return english ? "search result, not saved" : "kết quả tìm kiếm, chưa lưu" }
        return intent.visited ? (english ? "visited" : "đã ghé") : (english ? "want to visit" : "muốn ghé")
    }
}

struct PlaceRow: View {
    let place: PrototypePlace
    let english: Bool
    var intent: SavedIntent? = nil
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: place.status == "CLOSED_PERMANENTLY" ? "building.2.crop.circle" : "leaf.circle")
                .font(.title).foregroundStyle(G2Style.green).frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                Text(place
                    .status == "CLOSED_PERMANENTLY" ?
                    (english ? "Permanently closed · fixture" : "Đóng cửa vĩnh viễn · mẫu") : place.subtitle)
                    .font(.caption).foregroundStyle(place.status == "CLOSED_PERMANENTLY" ? G2Style.coral : .secondary)
                if let intent {
                    Label(
                        intent.visited ? (english ? "Visited" : "Đã ghé") : (english ? "Want to visit" : "Muốn ghé"),
                        systemImage: intent.visited ? "checkmark.circle" : "bookmark"
                    ).font(.caption)
                        .foregroundStyle(G2Style.green)
                }
            }
            Spacer(minLength: 4); Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                .accessibilityHidden(true)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Medium detent is the bottom sheet (no Google request); "Details" is the explicit trigger for a fresh Details call.
struct PlaceDetail: View {
    @ObservedObject var model: AppModel
    let place: PrototypePlace
    @ObservedObject private var lab: PlacesLab
    @State private var detent = PresentationDetent.medium
    @State private var detailsLoaded = false
    @State private var detailsFailed = false
    @State private var media = false
    @State private var reviews = false
    @State private var label = ""
    @State private var collection = ""
    @State private var directions = false
    @State private var moved = false
    @State private var movedTarget: PrototypePlace?
    @Environment(\.dismiss) private var dismiss
    init(model: AppModel, place: PrototypePlace) {
        self.model = model; self.place = place; lab = model.places
    }

    private var intent: SavedIntent? {
        model.saved.first { $0.placeID == place.id }
    }

    private var expired: Bool {
        lab.scenario == .expired
    }

    private var moments: [DraftSummary] {
        model.drafts.filter { $0.placeID == place.id && !$0.hidden }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    summary
                    if detent == .large || detailsLoaded {
                        Divider()
                        googleBlock
                        Divider()
                        dodayBlock
                    }
                    Label(
                        model.t("Riêng tư · GPS không bao giờ tự đặt Đã ghé", "Private · GPS never sets Visited"),
                        systemImage: "lock"
                    ).font(.caption).foregroundStyle(.secondary)
                }.padding(20)
            }
            .navigationTitle(model.t("Địa điểm", "Place")).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(model.t("Đóng", "Close")) { dismiss() }.accessibilityIdentifier("place.close")
                }
            }
            .onAppear { label = intent?.userLabel ?? ""; collection = intent?.collection ?? "" }
            .alert(model.t("Chỉ đường bằng Google Maps", "Directions in Google Maps"), isPresented: $directions) {
                Button("OK", role: .cancel) {}.accessibilityIdentifier("directions.ok")
            } message: { Text(model.t(
                "Bản thử: bước này mở Google Maps tới đúng Place ID, không gửi vị trí của bạn. "
                    + "Đây là Place ID mẫu nên không mở để tránh chỉ đường sai. G2 Lab có nút mở với Place ID thật.",
                "Prototype: this step opens Google Maps to the exact Place ID without sending your location. "
                    + "This is a fixture ID, so nothing opens to avoid a wrong route. G2 Lab can open a real Place ID."
            )) }
            .confirmationDialog(
                model.t("Địa điểm đã chuyển", "Place moved"),
                isPresented: $moved,
                titleVisibility: .visible
            ) {
                Button(model.t("Xem nơi mới", "View the new place")) { movedTarget = PrototypePlace.fixtures[1] }
                Button(model.t("Giữ bản lưu hiện tại", "Keep my current saved place")) {}
            } message: { Text(model.t(
                "Doday không tự đổi bản lưu, khoảnh khắc, bộ sưu tập hay Đã ghé. Bạn có thể lưu nơi mới riêng.",
                "Doday never moves your saved place, moments, collections or Visited automatically. You can save the new place separately."
            )) }
            .sheet(item: $movedTarget) { PlaceDetail(model: model, place: $0) }
        }
        .presentationDetents([.medium, .large], selection: $detent).presentationDragIndicator(.visible)
    }

    @ViewBuilder private var summary: some View {
        Text(expired ? (intent?.userLabel.isEmpty == false ? intent!.userLabel : model.t(
            "Địa điểm đã lưu",
            "Saved place"
        )) : place.name)
            .font(.title2.bold()).accessibilityIdentifier("place.title")
        if expired {
            Label(
                model.t(
                    "Không còn dữ liệu được phép hiển thị; Place ID và bản lưu vẫn còn.",
                    "Display rights expired; the Place ID and your save remain."
                ),
                systemImage: "clock.badge.exclamationmark"
            ).font(.footnote).foregroundStyle(.secondary)
        } else {
            Label(
                model.t("Dữ liệu mẫu Doday · không phải Google", "Doday fixture data · not Google"),
                systemImage: "testtube.2"
            ).font(.footnote).foregroundStyle(.secondary)
        }
        HStack(spacing: 12) {
            Button {
                if intent == nil {
                    model.save(place)
                } else {
                    model.unsave(place.id)
                }
            } label: {
                Label(
                    intent == nil ? model.t("Lưu", "Save") : model.t("Đã lưu", "Saved"),
                    systemImage: intent == nil ? "bookmark" : "bookmark.fill"
                )
            }.buttonStyle(.borderedProminent).accessibilityIdentifier(intent == nil ? "place.save" : "place.saved")
                .accessibilityHint(intent == nil ? "" : model.t("Chạm để bỏ lưu", "Tap to remove from saved"))
            Button { directions = true } label: { Label(
                model.t("Chỉ đường", "Directions"),
                systemImage: "arrow.triangle.turn.up.right.diamond"
            ) }
            .buttonStyle(.bordered).accessibilityIdentifier("place.directions")
        }
        if intent != nil {
            Picker(
                model.t("Trạng thái", "Status"),
                selection: Binding(get: { intent?.visited ?? false }, set: { model.setVisited(place.id, $0) })
            ) {
                Text(model.t("Muốn ghé", "Want to visit")).tag(false)
                Text(model.t("Đã ghé", "Visited")).tag(true)
            }.pickerStyle(.segmented).accessibilityIdentifier("place.status")
            TextField(model.t("Tên do bạn đặt (tùy chọn)", "Your label (optional)"), text: $label)
                .textFieldStyle(.roundedBorder)
            TextField(model.t("Bộ sưu tập (tùy chọn)", "Collection (optional)"), text: $collection)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("place.collection")
            Button(model.t("Cập nhật bản lưu", "Update saved place")) { model.save(
                place,
                label: label,
                collection: collection
            ) }
            .accessibilityIdentifier("place.update")
        }
        if detent == .medium && !detailsLoaded {
            Button { loadDetails() } label: {
                Label(model.t("Xem chi tiết", "View details"), systemImage: "info.circle")
            }
            .disabled(expired && lab.unavailable).accessibilityIdentifier("place.details")
        }
    }

    @ViewBuilder private var googleBlock: some View {
        Text(model.t("Thông tin địa điểm", "Place information")).font(.headline)
        if !detailsLoaded {
            Button { loadDetails() } label: { Label(
                model.t("Tải thông tin mới", "Load current information"),
                systemImage: "arrow.clockwise"
            ) }
            .accessibilityIdentifier("place.loadDetails")
        } else if detailsFailed {
            Label(
                model.t(
                    "Không cập nhật được thông tin lúc này. Không hiển thị trạng thái cũ như hiện tại; chỉ đường vẫn dùng được.",
                    "Could not update information right now. Old status is not shown as current; directions still work."
                ),
                systemImage: "wifi.exclamationmark"
            ).font(.footnote)
            Button(model.t("Thử lại", "Retry")) { loadDetails() }
        } else {
            if place.status == "CLOSED_PERMANENTLY" || lab.scenario == .closed {
                Label(
                    model
                        .t(
                            "Đóng cửa vĩnh viễn. Bản lưu của bạn được giữ.",
                            "Permanently closed. Your saved place is kept."
                        ),
                    systemImage: "exclamationmark.triangle.fill"
                )
                .foregroundStyle(G2Style.coral).accessibilityIdentifier("place.closed")
            } else {
                LabeledContent(model.t("Trạng thái", "Status"), value: model.t("Đang hoạt động", "Operational"))
                LabeledContent(model.t("Giờ mở cửa", "Hours"), value: place.hours)
                LabeledContent(model.t("Đánh giá · lượt", "Rating · count"), value: place.rating)
            }
            if lab.scenario == .moved {
                Button { moved = true } label: { Label(
                    model.t("Địa điểm này đã chuyển", "This place has moved"),
                    systemImage: "arrow.up.right.square"
                ) }
                .accessibilityIdentifier("place.moved")
            }
            Text(model.t(
                "Nguồn: dữ liệu mẫu Doday. Khi live: “Google Maps” và attribution theo trường.",
                "Source: Doday fixture. When live: “Google Maps” and per-field attribution."
            ))
            .font(.caption2).foregroundStyle(.secondary)
            Button { lab.record(.viewPhotos); media = true } label: { Label(
                model.t("Xem ảnh", "View photos"),
                systemImage: "photo.on.rectangle"
            ) }
            .accessibilityIdentifier("place.photos")
            if media {
                if !lab.unavailable && !expired {
                    if let image = UIImage(data: AppModel.fixtureImage()) {
                        Image(uiImage: image).resizable().scaledToFit().frame(maxHeight: 180)
                            .accessibilityLabel(model.t(
                                "Ảnh mẫu",
                                "Fixture image"
                            ))
                    }
                    Text(model.t(
                        "Ảnh mẫu của Doday · không phải Google Photos",
                        "Doday synthetic image · not Google Photos"
                    )).font(.caption).foregroundStyle(.secondary)
                } else {
                    Text(model.t(
                        "Không tải được ảnh. Thông tin khác vẫn dùng được.",
                        "Photos unavailable. Other information still works."
                    )).font(.footnote)
                }
            }
            Button { lab.record(.viewReviews); reviews = true } label: { Label(
                model.t("Xem từng đánh giá", "View individual reviews"),
                systemImage: "text.bubble"
            ) }
            .accessibilityIdentifier("place.reviews")
            if reviews {
                if !lab.unavailable && !expired {
                    Text(model.t(
                        "Người thử A (mẫu) · sắp xếp: liên quan nhất",
                        "Tester A (fixture) · sort: most relevant"
                    )).font(.caption).foregroundStyle(.secondary)
                    Text(model.t(
                        "Một điểm dừng dễ chịu cho cuối tuần. [nội dung giả]",
                        "A pleasant weekend stop. [synthetic text]"
                    ))
                } else {
                    Text(model.t(
                        "Không tải được đánh giá. Thông tin khác vẫn dùng được.",
                        "Reviews unavailable. Other information still works."
                    )).font(.footnote)
                }
            }
        }
    }

    @ViewBuilder private var dodayBlock: some View {
        Text(model.t("Khoảnh khắc của bạn tại đây", "Your moments here")).font(.headline)
        if moments.isEmpty {
            Text(model.t(
                "Chưa có khoảnh khắc ở đây. Chụp một ảnh để giữ kỷ niệm riêng.",
                "No moments here yet. Capture one to keep a private memory."
            ))
            .font(.subheadline).foregroundStyle(.secondary)
            Button(model.t("Mở Camera", "Open Camera")) { model.activeArea = 0; dismiss() }.font(.subheadline)
        } else {
            ForEach(moments) { draft in
                Label(draft.title.isEmpty ? model.t("Khoảnh khắc", "Moment") : draft.title, systemImage: "photo")
                    .font(.subheadline)
            }
        }
    }

    private func loadDetails() {
        detent = .large
        lab.record(.details)
        detailsFailed = lab.unavailable || expired
        detailsLoaded = true
    }
}

struct SavedScreen: View {
    @ObservedObject var model: AppModel
    @State private var filter = 0
    @State private var collection = ""
    @State private var selected: PrototypePlace?
    private var items: [SavedIntent] {
        model.saved
            .filter {
                (filter == 0 || (filter == 1 ? !$0.visited : $0.visited)) &&
                    (collection.isEmpty || $0.collection == collection)
            }
    }

    var body: some View {
        List {
            Section {
                Picker(model.t("Trạng thái", "Status"), selection: $filter) {
                    Text(model.t("Tất cả", "All")).tag(0); Text(model.t("Muốn ghé", "Want to visit"))
                        .tag(1); Text(model.t(
                            "Đã ghé",
                            "Visited"
                        )).tag(2)
                }.pickerStyle(.segmented)
                Picker(model.t("Bộ sưu tập", "Collection"), selection: $collection) {
                    Text(model.t("Tất cả", "All")).tag("")
                    ForEach(Array(Set(model.saved.map(\.collection))).filter { !$0.isEmpty }.sorted(), id: \.self) {
                        Text($0).tag($0)
                    }
                }
                NavigationLink { PendingScreen(model: model) } label: {
                    Label(model.t("Chờ xử lý", "Pending"), systemImage: "tray").badge(model.pending.count)
                }
            }
            if items.isEmpty {
                ContentUnavailableView(
                    model.t("Chưa có nơi đã lưu", "No saved places"),
                    systemImage: "bookmark",
                    description: Text(model.t("Tìm trên Bản đồ rồi chạm Lưu.", "Search on Map, then tap Save."))
                )
            }
            ForEach(items) { item in
                if model.places.scenario != .expired, let fixture = PrototypePlace.fixture(item.placeID) {
                    Button { selected = fixture } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            PlaceRow(place: fixture, english: model.english, intent: item)
                            if !item.userLabel.isEmpty {
                                Text(item.userLabel).font(.footnote)
                            }
                            if !item.collection
                                .isEmpty
                            {
                                Label(item.collection, systemImage: "folder").font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }.buttonStyle(.plain).accessibilityIdentifier("saved." + item.placeID)
                } else {
                    Button { selected = PrototypePlace.fixture(item.placeID) } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.userLabel.isEmpty ? model.t("Nơi đã lưu", "Saved place") : item.userLabel)
                            Text("ID: " + item.placeID).font(.caption.monospaced())
                            Text(model.t(
                                "Thiếu dữ liệu hợp lệ để vẽ marker; không tự gọi Places. Mở để làm mới chủ động.",
                                "No valid data for a marker; no automatic Places request. Open to refresh on demand."
                            )).font(.caption).foregroundStyle(.secondary)
                        }
                    }.buttonStyle(.plain)
                }
            }.onDelete { offsets in
                for offset in offsets {
                    model.unsave(items[offset].placeID)
                }
            }
        }.navigationTitle(model.t("Nơi đã lưu", "Saved places")).navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selected) { PlaceDetail(model: model, place: $0) }
    }
}
