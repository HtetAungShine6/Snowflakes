//
//  TransactionResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 16/2/25.
//

struct TransactionResponse: Codable {
    let success: Bool
    let message: [TransactionMessage]
}

struct TransactionMessage: Codable {
    let roundNumber: Int
    let teamId: String?
    let shopId: String?
    let productId: String
    let productName: String
    let imageId: String?
    let imageName: String?
    let quantity: Int
    let total: Int
}
