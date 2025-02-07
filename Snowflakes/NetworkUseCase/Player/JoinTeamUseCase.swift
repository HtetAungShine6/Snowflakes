//
//  JoinTeamUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 3/2/25.
//

import Foundation

class JoinTeamUseCase: APIManager {
    typealias ModelType = PlayerTeamJoinResponse
    var methodPath: String {
        return "/player/status"
    }
}
