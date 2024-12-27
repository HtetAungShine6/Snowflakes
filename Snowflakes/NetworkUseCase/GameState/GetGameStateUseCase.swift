//
//  GetGameStateUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

class GetGameStateUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
    }
    
    typealias ModelType = GameStateResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/gamestate?hostRoomCode=\(hostRoomCode)"
        } else if let playerRoomCode = playerRoomCode {
            return "/gamestate?playerRoomCode=\(playerRoomCode)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}
