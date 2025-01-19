//
//  CreatePlayerUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

import Foundation

class CreatePlayerUseCase: APIManager {
    typealias ModelType = PlayerResponse
    var methodPath: String {
        return "/player"
    }
}
