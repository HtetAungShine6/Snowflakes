//
//  ShopExchangeDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/2/25.
//


struct ShopExchangeDTO: Codable {
    let roundNumber: Int
    let playerRoomCode: String
    let hostRoomCode: String
    let teamNumber: Int
    let products: [ProductDTO]
}

struct ProductDTO: Codable {
    let productName: String
    let quantity: Int
}

struct ShopExchangeResponse: Codable {
    let success: Bool
    let message: String
}
