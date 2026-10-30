import SwiftUI

struct ContentView: View {
    var body: some View {
        // NavigationView thay cho NavigationStack vì app hỗ trợ từ iOS 15
        NavigationView {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                    .accessibilityHidden(true)
                Text("Xin chào, Doday")
                    .font(.title2)
            }
            .navigationTitle("Doday")
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
