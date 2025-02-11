//
//  GetTeamDetailUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 9/2/25.
//

import Foundation

class GetTeamDetailByRoomCodeUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    let teamNumber: Int
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil, teamNumber: Int) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = TeamDetailResponse
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/team/teamdetails?teamNumber=\(teamNumber)&hostRoomCode=\(hostRoomCode)"
        } else if let playerRoomCode = playerRoomCode {
            return "/team/teamdetails?teamNumber=\(teamNumber)&playerRoomCode=\(playerRoomCode)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}
