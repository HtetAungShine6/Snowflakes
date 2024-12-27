//
//  PostGameStateUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

import Foundation

class PostGameStateUseCase: APIManager {
    typealias ModelType = GameStateResponse
    var methodPath: String {
        return "/gamestate"
    }
}
