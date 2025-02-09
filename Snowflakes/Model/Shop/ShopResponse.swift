//
//  ShopResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 8/2/25.
//

struct ShopResponse: Codable {
    let success: Bool
    let message: ShopMessageResponse
}

struct ShopMessageResponse: Codable {
    let id: String
    let hostRoomCode: String
    let playerRoomCode: String
    let tokens: Int
    let shopStocks: [ShopItem]
}
