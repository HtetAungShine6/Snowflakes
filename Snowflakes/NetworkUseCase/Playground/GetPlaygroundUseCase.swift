//
//  GetPlaygroundUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 21/1/2568 BE.
//

import Foundation

class GetPlaygroundUseCase: APIManager {
    
    let hostRoomCode: String
    
    init(hostRoomCode: String) {
        self.hostRoomCode = hostRoomCode
    }
    
    typealias ModelType = PlaygroundResponse
    
    var methodPath: String {
        return "/playground/hostroomcode?hostRoomCode=\(hostRoomCode)"
    }
}
