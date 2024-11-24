//
//  CreateTeamResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

struct CreateTeamResponse: Codable {
    let teamNumber: Int
    let maxMembers: Int
    let tokens: Int
}
