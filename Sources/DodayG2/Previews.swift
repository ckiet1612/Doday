#if DEBUG
    import SwiftUI

    /// Xcode canvas previews (Editor ▸ Canvas, ⌥⌘↩): edit a screen and it redraws in place, without a rebuild and
    /// relaunch. Fixture data only, like the UI tests; previews are design aids, never device or field evidence.
    @MainActor
    private func previewModel(
        signedIn: Bool = true,
        english: Bool = false,
        onboarding: Bool = false,
        setup: (AppModel) -> Void = { _ in }
    ) -> AppModel {
        var arguments = ["--g2-ui-test"]
        if english {
            arguments.append("--g2-english")
        }
        if onboarding {
            arguments.append("--g2-onboarding")
        }
        let model = AppModel(arguments: arguments)
        if signedIn {
            model.login()
        }
        setup(model)
        return model
    }

    private extension View {
        /// Screens shown on their own lose the tint RootView gives every sheet in the app.
        func inAppTint() -> some View {
            tint(G2Style.green)
        }
    }

    #Preview("Lần đầu mở") {
        RootView(model: previewModel(signedIn: false, onboarding: true))
    }

    #Preview("Camera · chưa đăng nhập") {
        RootView(model: previewModel(signedIn: false))
    }

    #Preview("Camera") {
        RootView(model: previewModel())
    }

    #Preview("Camera · English") {
        RootView(model: previewModel(english: true))
    }

    #Preview("Xem lại ảnh") {
        ReviewScreen(model: previewModel { $0.capture(AppModel.fixtureImage(), origin: "fixture") }).inAppTint()
    }

    #Preview("Chọn địa điểm · vùng chặn") {
        PlaceChooser(model: previewModel {
            $0.capture(AppModel.fixtureImage(), origin: "fixture"); $0.currentHideChanged(false)
        }) { _ in }.inAppTint()
    }

    #Preview("Bản đồ") {
        RootView(model: previewModel { $0.activeArea = 1 })
    }

    #Preview("Chi tiết địa điểm") {
        PlaceDetail(model: previewModel(), place: PrototypePlace.fixtures[0]).inAppTint()
    }

    #Preview("Đã lưu") {
        NavigationStack {
            SavedScreen(model: previewModel { $0.save(PrototypePlace.fixtures[0]) })
        }.inAppTint()
    }

    #Preview("Chờ xử lý") {
        NavigationStack {
            PendingScreen(model: previewModel { _ = $0.addLink("https://www.tiktok.com/@fixture/video/123") })
        }.inAppTint()
    }

    #Preview("Hồ sơ") {
        ProfileScreen(model: previewModel()).inAppTint()
    }

    #Preview("Cài đặt riêng tư") {
        NavigationStack {
            PrivacySettings(model: previewModel())
        }.inAppTint()
    }

    #Preview("Lab") {
        NavigationStack {
            LabScreen(model: previewModel())
        }.inAppTint()
    }

    #Preview("Hàng địa điểm") {
        List(PrototypePlace.fixtures) { PlaceRow(place: $0, english: false) }.inAppTint()
    }
#endif
