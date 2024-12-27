//
//  GameStateResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

struct GameStateResponse: Codable {
    let success: Bool
    let message: GameStateMessage
}

struct GameStateMessage: Codable, Hashable {
    let hostRoomCode: String
    let playerRoomCode: String
    let currentGameState: String
}
