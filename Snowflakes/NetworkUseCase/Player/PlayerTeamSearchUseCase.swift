//
//  PlayerTeamSearchUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 5/2/25.
//

import Foundation

class PlayerTeamSearchUseCase: APIManager {
    
    let playerName: String
    let roomCode: String
    let teamNumber: String
    
    init(playerName: String, roomCode: String, teamNumber: String) {
        self.playerName = playerName
        self.roomCode = roomCode
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = PlayerTeamSearchResponse
    
    var methodPath: String {
        return "/player/search?playerName=\(playerName)&roomCode=\(roomCode)&teamNumber=\(teamNumber)"
    }
}
