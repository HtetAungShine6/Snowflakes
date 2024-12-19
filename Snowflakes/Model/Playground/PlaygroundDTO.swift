//
//  PlaygroundDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/12/2024.
//

struct PlaygroundDTO: Codable {
    let hostRoomCode: String
    let playerRoomCode: String
    let hostId: String
    let rounds: [String: String]
    let numberOfTeam: Int
    let maxTeamMember: Int
    let teamToken: Int
}
