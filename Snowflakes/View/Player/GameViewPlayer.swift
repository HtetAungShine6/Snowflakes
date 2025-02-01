//import SwiftUI
//
//struct GameViewPlayer: View {
//    
//    @EnvironmentObject var navigationManager: NavigationManager
//    
//    var body: some View {
//        Group {
//            if navigationManager.isShopTime {
//                PlayerShopTimerView(
//                    navBarTitle: "Snowflake",
//                    navBarSubtitle: "Shop Round",
//                    image: Image("Shop 1")
//                )
//            } else {
//                PlayerTimerView(
//                    navBarTitle: "Snowflake",
//                    navBarSubtitle: "Player Round",
//                    image: Image("Snowman")
//                )
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//}

//#Preview {
//    let navigationManager = NavigationManager()
//    navigationManager.isShopTime = false // Toggle this to true for testing the shop view
//    
//    return GameViewPlayer()
//        .environmentObject(navigationManager)
//}
