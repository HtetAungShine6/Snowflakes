//
//  GetPlayerUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

import Foundation

class GetPlayerUseCase: APIManager {
    
    let playerName: String?
    let roomCode: String?
    let teamNumber: String?
    
    init(playerName: String? = nil, roomCode: String? = nil, teamNumber: String? = nil) {
        self.playerName = playerName
        self.roomCode = roomCode
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = PlayerResponse
    
    var methodPath: String {
        if let playerName = playerName, let roomCode = roomCode, let teamNumber = teamNumber {
            return "/team/search?playerName=\(playerName)&roomCode=\(roomCode)&teamNumber=\(teamNumber)"
        } else if let playerName = playerName, let roomCode = roomCode {
            return "/team/search?playerName=\(playerName)&roomCode=\(roomCode)"
        } else {
            return "/team/search"
        }
    }
}

