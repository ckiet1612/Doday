import SwiftUI

@main
struct G2App: App {
    @StateObject private var model = AppModel()
    var body: some Scene {
        WindowGroup { RootView(model: model) }
    }
}
