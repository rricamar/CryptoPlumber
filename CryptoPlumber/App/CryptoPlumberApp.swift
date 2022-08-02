import SwiftUI


@main
struct CryptoPlumberApp: App {
    
    @StateObject private var homeVm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeVm)
        }
    }
}
