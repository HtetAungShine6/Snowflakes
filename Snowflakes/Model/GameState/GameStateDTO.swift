//
//  GameStateDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

struct GameStateDTO: Codable {
    let hostRoomCode: String
    let playerRoomCode: String
    let currentGameState: GameState
}
