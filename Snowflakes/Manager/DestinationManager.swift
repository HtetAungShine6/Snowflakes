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
    case teamListView(team: [Team])
    case hostTimerView(roomCode: String)
    case hostShopTimerView(roomCode: String)
//    case gameView
    case hostShopView
    case teamListPlayerView(team: [Team])
    case teamDetailsPlayerView(teamNumber: Int, balance: Int, scissorsCount: Int, paperCount: Int, penCount: Int)
//    case hostTeamDetailView(team: [Team])
//    case timerPlayerView
//    case shopTimerPlayerView
    case gameViewPlayer
}
