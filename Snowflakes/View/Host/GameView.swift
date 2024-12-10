//
//  GameView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 08/12/2024.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var isShopTime: Bool = true
    
    var body: some View {
        if !isShopTime {
            HostTimerView(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Snowman"))
                .navigationBarBackButtonHidden()
        } else {
            HostShopTimer(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Shop2"))
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    GameView()
}
