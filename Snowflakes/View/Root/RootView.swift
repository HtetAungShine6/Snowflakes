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
                    case .teamListView(let hostRoomCode, let playerRoomCode):
                        TeamListView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode)
                            .environmentObject(navigationManager)
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
                            teamNumber: teamNumber,
                            balance: balance,
                            scissorsCount: scissorsCount,
                            paperCount: paperCount,
                            penCount: penCount
                        )
                        .environmentObject(navigationManager)
                    case .hostTeamDetailView(let team):
                        HostTeamDetailView(team: team)
                        .environmentObject(navigationManager)
                    }
                }
        }
    }
}


