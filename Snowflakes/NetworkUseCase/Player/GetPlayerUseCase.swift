//
//  GetPlayerUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

import Foundation

class GetPlayerUseCase: APIManager{
    typealias ModelType = PlayerResponse
    
    var id: String
    
    init(id: String){
        self.id = id
    }
    
    var methodPath: String{
        return "/player/\(id)"
    }
}
