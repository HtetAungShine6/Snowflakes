//
//  TeamListMockUp.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/11/2024.
//

struct TeamMockUp {
    let teamNumber: Int
    let code: Int
    let playersCount: Int
    let items: [String: Int]
    let tokens: Int
    let members: [String]
}

let teamListMockUp: [TeamMockUp] = [
    TeamMockUp(
        teamNumber: 1,
        code: 1,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"]
    ),
    TeamMockUp(
        teamNumber: 2,
        code: 2,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"]
    ),
    TeamMockUp(
        teamNumber: 3,
        code: 3,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"]
    )
]
