//
//  PlayerTeamJoinDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 3/2/25.
//

struct PlayerTeamJoinDTO: Codable {
    let playerName: String
    let teamNumber: Int
    let playerRoomCode: String
    let status: String
}

struct PlayerTeamJoinResponse: Codable {
    let success: Bool
    let message: String
}
