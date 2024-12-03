//
//  LeaderboardMockUp.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

struct LeaderboardMockUp: Hashable {
    let teamNumber: Int
    let code: Int
    let playersCount: Int
    let items: [String: Int]
    let tokens: Int
    let members: [String]
    let rank: String
}

let leaderboardMockUp: [LeaderboardMockUp] = [
    LeaderboardMockUp(
        teamNumber: 1,
        code: 1,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"],
        rank: "2nd"
    ),
    LeaderboardMockUp(
        teamNumber: 2,
        code: 2,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"],
        rank: "1st"
    ),
    LeaderboardMockUp(
        teamNumber: 3,
        code: 3,
        playersCount: 3,
        items: ["scissors": 1, "paper": 1, "pen": 1],
        tokens: 5,
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"],
        rank: "3rd"
    )
]
