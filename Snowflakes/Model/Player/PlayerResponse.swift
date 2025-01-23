//
//  PlayerResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

struct PlayerResponse: Codable {
    let success: Bool
    let message: PlayerResponseMessage
}

struct PlayerResponseMessage: Codable {
    let playerName: String
    let roomCode: String
    let id: String
    let teamNumber: Int?
}
