//
//  GameView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 08/12/2024.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
//    @State private var isShopTime: Bool = false
    
    var body: some View {
        Group {
            if navigationManager.isShopTime {
                HostShopTimer(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Shop 1"))
            } else {
                HostTimerView(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Snowman"))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GameView()
}
