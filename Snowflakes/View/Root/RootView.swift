//
//  RootView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

import SwiftUI

struct RootView: View {
    @StateObject private var navigationManager = NavigationManager()

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HostScreenView()
                .environmentObject(navigationManager) 
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .hostSettingView:
                        HostSettingView()
                    case .teamListView(let roomCode):
                        TeamListView(roomCode: roomCode)
                    case .hostTimerView(let title, let subtitle, let imageName):
                        HostTimerView(navBarTitle: title, navBarSubtitle: subtitle, image: Image(imageName))
                    case .hostShopView:
                        HostShopView()
                    }
                }
        }
    }
}


