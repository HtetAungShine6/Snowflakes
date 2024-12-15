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
                            .environmentObject(navigationManager)
                    case .teamListView(let roomCode):
                        TeamListView(roomCode: roomCode)
                            .environmentObject(navigationManager)
                        //                    case .hostTimerView(let title, let subtitle, let imageName):
                        //                        HostTimerView(navBarTitle: title, navBarSubtitle: subtitle, image: Image(imageName))
                        //                            .environmentObject(navigationManager)
                    case .gameView:
                        GameView()
                            .environmentObject(navigationManager)
                    case .hostShopView:
                        HostShopView()
                            .environmentObject(navigationManager)
                    case .teamListPlayerView(let roomCode):
                        TeamListPlayerView(roomCode: roomCode)
                            .environmentObject(navigationManager)
                    case .teamDetailsPlayerView(let teamNumber, let balance, let scissorsCount, let paperCount, let penCount):
                        TeamDetailsPlayerView(
                            team: TeamMockUp(
                                teamNumber: teamNumber,
                                code: 1234, // You can replace this with the actual team code
                                playersCount: 3,
                                items: ["scissors": scissorsCount, "paper": paperCount, "pen": penCount],
                                tokens: balance,
                                members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"] // Example members
                            ),
                            members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"] // Example members
                        )
                        .environmentObject(navigationManager)

                    }
                }
        }
    }
}


