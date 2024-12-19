//
//  CreateTeamUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import Foundation

class CreateTeamUseCase: APIManager {
    typealias ModelType = CreateTeamResponse
    var methodPath: String {
        return "/team"
    }
}
