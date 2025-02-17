//
//  AddToCartResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

struct AddToCartResponse: Codable {
    let success: Bool
    let message: [AddToCartResponseMessage]
}
