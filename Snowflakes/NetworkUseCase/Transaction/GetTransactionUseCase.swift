//
//  GetTransactionUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 16/2/25.
//

import Foundation

class GetTransactionUseCase: APIManager {
    
    let hostRoomCode: String?
    let playerRoomCode: String?
    let roundNumber: Int
    let teamNumber: Int
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.roundNumber = roundNumber
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = TransactionResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/transaction?hostRoomCode=\(hostRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else if let playerRoomCode = playerRoomCode {
            return "/transaction?playerRoomCode=\(playerRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}

class GetItemTransitionUseCase: APIManager {
    let hostRoomCode: String?
    let playerRoomCode: String?
    let roundNumber: Int
    let teamNumber: Int
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.roundNumber = roundNumber
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = ItemTransitionResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/transaction/itemtransactions?hostRoomCode=\(hostRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else if let playerRoomCode = playerRoomCode {
            return "/transaction/itemtransactions?playerRoomCode=\(playerRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}

class GetImageTransitionUseCase: APIManager {
    let hostRoomCode: String?
    let playerRoomCode: String?
    let roundNumber: Int
    let teamNumber: Int
    
    init(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.roundNumber = roundNumber
        self.teamNumber = teamNumber
    }
    
    typealias ModelType = ImageTransitionResponse
    
    var methodPath: String {
        if let hostRoomCode = hostRoomCode {
            return "/transaction/imagetransactions?hostRoomCode=\(hostRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else if let playerRoomCode = playerRoomCode {
            return "/transaction/imagetransactions?playerRoomCode=\(playerRoomCode)&roundNumber=\(roundNumber)&teamNumber=\(teamNumber)"
        } else {
            fatalError("Either hostRoomCode or playerRoomCode must be provided.")
        }
    }
}
