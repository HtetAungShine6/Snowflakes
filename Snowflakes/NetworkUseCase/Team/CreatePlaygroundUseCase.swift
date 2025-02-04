//
//  CreatePlaygroundUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/12/2024.
//

import Foundation

class CreatePlaygroundUseCase: APIManager {
    typealias ModelType = PlaygroundResponse
    var methodPath: String {
        return "/playground"
    }
}
