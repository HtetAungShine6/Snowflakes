//
//  GetAddToCartUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

class GetAddToCartUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    let teamNumber: Int
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil, teamNumber: Int) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = AddToCartResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/cart?hostRoomCode=\(hostRoomCode)&teamNumber=\(teamNumber)"
        } else if let playerRoomCode = playerRoomCode {
            return "/cart?playerRoomCode=\(playerRoomCode)&teamNumber=\(teamNumber)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided to call Add to Cart API.")
        }
    }
}
