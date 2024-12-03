//
//  SnowflakesApp.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 04/11/2024.
//

import SwiftUI

@main
struct SnowflakesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
//            SigninView()
            //            HostShopTimer(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Snowman"))
            //            .environmentObject(navigationManager)
            RootView()
        }
    }
}

