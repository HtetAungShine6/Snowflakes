//
//  TeamSearchResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 22/12/2024.
//

struct TeamSearchResponse: Codable {
    let success: Bool
    let message: [Team]
}

struct Team: Codable, Hashable {
    let teamNumber: Int
    let hostRoomCode: String
    let playerRoomCode: String
    let tokens: Int
    let members: [String]?
    let teamStocks: [ShopItem]
}
