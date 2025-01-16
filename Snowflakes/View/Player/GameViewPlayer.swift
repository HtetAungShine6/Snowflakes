//
//  GameViewPlayer.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 25/12/2024.
//

import SwiftUI

struct GameViewPlayer: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
//    @State private var isShopTime: Bool = false
    
    var body: some View {
        Group {
            if navigationManager.isShopTime {
//                HostShopTimer(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Shop 1"))
            } else {
                PlayerTimerView(navBarTitle: "Snowflakes", navBarSubtitle: "Shop Round", image: Image("Snowman")) // Wrong View called
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GameViewPlayer()
}
