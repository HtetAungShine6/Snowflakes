//
//  WebSocketResponse.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/12/2024.
//

struct WebSocketResponse: Codable {
    let type: Int
    let target: String?
    let arguments: [String]?
}
