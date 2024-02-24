import SwiftUI

class SharedData: ObservableObject {
    @Published var points: Int = 0
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environmentObject(SharedData())
            }
    }
}
