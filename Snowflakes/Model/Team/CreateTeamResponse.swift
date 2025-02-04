//
//  CreateTeamResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import Foundation

struct CreateTeamResponse: Codable {
    let success: Bool
    let message: TeamEntity
}

struct TeamEntity: Codable {
    let teamNumber: Int
    let maxMembers: Int
    let tokens: Int
    let id: String
    let creationDate: String
    let modifiedDate: String?
}
