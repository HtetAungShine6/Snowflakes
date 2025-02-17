//
//  BuyImageDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/2/25.
//

struct BuyImageDTO: Codable {
    let isBuyingConfirm: Bool
    let hostRoomCode: String
    let playerRoomCode: String
    let roundNumber: Int
    let teamNumber: Int
    let imageUrl: String
    let price: Int
}

struct BuyImageResponse: Codable {
    let success: Bool
    let message: String
}
