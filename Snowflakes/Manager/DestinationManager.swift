//
//  DestinationManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

import SwiftUI

enum Destination: Hashable {
    case hostSettingView
    case joinRoomView
    case teamListView(hostRoomCode: String, playerRoomCode: String)
//    case hostTimerView(title: String, subtitle: String, imageName: String)
    case gameView
    case hostShopView
    case teamListPlayerView(roomCode: String)
    case teamDetailsPlayerView(teamNumber: Int, balance: Int, scissorsCount: Int, paperCount: Int, penCount: Int)
    case hostTeamDetailView(team: TeamMockUp)
//    case timerPlayerView
//    case shopTimerPlayerView
}
