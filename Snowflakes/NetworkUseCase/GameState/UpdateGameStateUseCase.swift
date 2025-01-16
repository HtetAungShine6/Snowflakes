//
//  UpdateGameStateUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/01/2025.
//

import Foundation

class UpdateGameStateUseCase: APIManager {
    typealias ModelType = UpdateGameStateResponse
    var methodPath: String {
        return "/gamestate"
    }
}
