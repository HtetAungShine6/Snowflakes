//
//  PlayerTeamSearchResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 5/2/25.
//

struct PlayerTeamSearchResponse: Codable {
    let success: Bool
    let message: PlayerTeamSearchMessage
}

struct PlayerTeamSearchMessage: Codable {
    let id: String
    let playerName: String
    let teamId: String
    let playerRoomCode: String
}
