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
                    case .joinRoomView:
                        JoinRoomView()
                            .environmentObject(navigationManager)
                    case .teamListView(let teams):
                        TeamListView(teams: teams)
                            .environmentObject(navigationManager)
//                    case .gameView:
//                        GameView()
//                            .environmentObject(navigationManager)
                    case .hostTimerView(let roomCode):
                        TimerViewHost(roomCode: roomCode)
                            .environmentObject(navigationManager)
                    case .hostShopTimerView(let roomCode):
                        ShopTimerViewHost(roomCode: roomCode)
                            .environmentObject(navigationManager)
                    case .hostShopView:
                        HostShopView()
                            .environmentObject(navigationManager)
                    case .teamListPlayerView(let teams):
                        TeamListPlayerView(teams: teams) 
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
                    case .gameViewPlayer:
                        GameViewPlayer()
                            .environmentObject(navigationManager)
//                    case .hostTeamDetailView(let team):
//                        HostTeamDetailView(team: team)
//                        .environmentObject(navigationManager)
                    }
                }
        }
    }
}


