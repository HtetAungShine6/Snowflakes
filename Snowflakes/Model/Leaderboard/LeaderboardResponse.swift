//
//  LeaderboardResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

struct LeaderboardResponse: Codable {
    let success: Bool
    let message: [LeaderboardMessage]
}

struct LeaderboardMessage: Codable {
    let teamNumber: Int
    let teamRank: Int
    let remainingTokens: Int
    let totalSales: Int
    let players: [String]
    let stocks: [ShopItem]
    let soldImages: [String]
}
