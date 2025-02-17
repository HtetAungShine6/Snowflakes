//
//  LeaderboardUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import Foundation

class LeaderboardUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
    }
    
    typealias ModelType = LeaderboardResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/leaderboard?hostRoomCode=\(hostRoomCode)"
        } else if let playerRoomCode = playerRoomCode {
            return "/leaderboard?playerRoomCode=\(playerRoomCode)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided to create Leaderboard.")
        }
    }
}
