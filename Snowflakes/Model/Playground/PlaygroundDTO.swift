//
//  PlaygroundDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/12/2024.
//

struct PlaygroundDTO: Codable {
    let hostRoomCode: String
    let playerRoomCode: String
    let rounds: [String: String]
    let numberOfTeam: Int
    let teamToken: Int
    let shopToken: Int
    let shop: [ShopItemDTO]
}

struct ShopItemDTO: Codable {
    let productName: String
    let price: Int
    let remainingStock: Int
}
