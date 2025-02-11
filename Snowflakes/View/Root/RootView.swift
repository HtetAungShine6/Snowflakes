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
                    case .teamListView(let hostRoomCode):
                        TeamListView(hostRoomCode: hostRoomCode)
                            .environmentObject(navigationManager)
                    case .hostTimerView(let roomCode):
                        TimerViewHost(roomCode: roomCode)
                            .environmentObject(navigationManager)
                    case .hostShopTimerView(let roomCode):
                        ShopTimerViewHost(roomCode: roomCode)
                            .environmentObject(navigationManager)
                    case .hostShopView(let hostRoomCode):
                        HostShopView(hostRoomCode: hostRoomCode)
                            .environmentObject(navigationManager)
                    case .teamListPlayerView(let playerRoomCode):
                        TeamListPlayerView(playerRoomCode: playerRoomCode)
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
                    case .leaderboard:
                        LeaderboardView()
                            .environmentObject(navigationManager)
                    case .playerTimerView(let hostRoomCode, let playerRoomCode):
                        PlayerTimerView(playerRoomCode: playerRoomCode, hostRoomCode: hostRoomCode)
                            .environmentObject(navigationManager)
                    case .playerShopTimerView(let hostRoomCode, let playerRoomCode):
                        PlayerShopTimerView(playerRoomCode: playerRoomCode, hostRoomCode: hostRoomCode)
                            .environmentObject(navigationManager)
                    case .shopDetailPlayerView(let playerRoomCode):
                        ShopDetailsPlayerView(playerRoomCode: playerRoomCode)
                            .environmentObject(navigationManager)
                    case .hostTeamDetailView(let hostRoomCode, let teamNumber):
                        HostTeamDetailView(teamNumber: teamNumber, hostRoomCode: hostRoomCode)
                            .environmentObject(navigationManager)
                    }
                }
        }
    }
}


