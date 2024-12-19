//
//  PlaygroundResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/12/2024.
//

import Foundation

struct PlaygroundResponse: Codable {
    let success: Bool
    let message: Message
}

struct Message: Codable {
    let hostRoomCode: String
    let playerRoomCode: String
    let hostId: String
    let numberOfTeam: Int
    let maxTeamMember: Int
    let teamToken: Int
    let rounds: [Round]
    let id: String
}

struct Round: Codable {
    let roundNumber: Int
    let duration: String
    let progress: String
}
