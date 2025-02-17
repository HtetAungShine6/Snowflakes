//
//  AddToCartDTO.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

struct AddToCartDTO: Codable {
    let hostRoomCode: String
    let playerRoomCode: String
    let productName: String
    let price: Int
    let quantity: Int
    let teamNumber: Int
}

struct AddToCartResponseMessage: Codable {
    let id: String
    let hostRoomCode: String
    let playerRoomCode: String
    let productName: String
    let price: Int
    let quantity: Int
    let teamNumber: Int
}
