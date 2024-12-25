//
//  SnowflakesApp.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 04/11/2024.
//

import SwiftUI

@main
struct SnowflakesApp: App {
    
    @StateObject private var navigationManager = NavigationManager()
//    @StateObject var createPlaygroundVM = CreatePlaygroundViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
//            TimerTestView()
//            TimerViewHost()
//            ShopTimerViewHost()
//            PlayerTimerView(navBarTitle: "Snowflake", navBarSubtitle: "player", image: Image("Snowman"))
        }
    }
}

