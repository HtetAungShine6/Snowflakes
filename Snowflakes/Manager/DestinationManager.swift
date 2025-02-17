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
    case teamListView(hostRoomCode: String)
    case hostTimerView(roomCode: String)
    case hostShopTimerView(roomCode: String)
    case hostShopView(hostRoomCode: String, roundNumber: Int)
    case teamListPlayerView(playerRoomCode: String)
    case teamDetailsPlayerView(teamNumber: Int, balance: Int, scissorsCount: Int, paperCount: Int, penCount: Int)
    case playerTimerView(hostRoomCode: String, playerRoomCode: String)
    case playerShopTimerView(hostRoomCode: String, playerRoomCode: String)
    case leaderboard(roomCode: String)
    case shopDetailPlayerView(playerRoomCode: String, roundNumber: Int)
    case hostTeamDetailView(hostRoomCode: String, teamNumber: Int, roundNumber: Int)
    case addToCartView(playerRoomCode: String, teamNumber: Int, roundNumber: Int, hostRoomCode: String)
    case galleryView(teamNumber: Int, roomCode: String)
}
