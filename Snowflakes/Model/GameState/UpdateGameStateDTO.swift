//
//  UpdateGameStateDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/01/2025.
//

struct UpdateGameStateDTO: Codable {
    let hostRoomCode: String
    let currentGameState: GameState
    let currentRoundNumber: Int
}
