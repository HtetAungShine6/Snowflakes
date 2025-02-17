//
//  LeaderboardUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import Foundation

class LeaderboardUseCase: APIManager {
    
    let hostRoomCode: String
    
    init(hostRoomCode: String) {
        self.hostRoomCode = hostRoomCode
    }
    
    typealias ModelType = LeaderboardResponse
    
    var methodPath: String {
        return "/leaderboard/\(hostRoomCode)"
    }
}
