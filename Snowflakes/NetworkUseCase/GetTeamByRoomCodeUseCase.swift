//
//  GetTeamByRoomCodeUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 22/12/2024.
//

import Foundation

class GetTeamByRoomCodeUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
    }
    
    typealias ModelType = TeamSearchResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/team/search?hostRoomCode=\(hostRoomCode)"
        } else if let playerRoomCode = playerRoomCode {
            return "/team/search?playerRoomCode=\(playerRoomCode)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}

