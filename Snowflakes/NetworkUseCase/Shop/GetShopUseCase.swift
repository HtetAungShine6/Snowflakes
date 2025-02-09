//
//  GetShopUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 8/2/25.
//

class GetShopUseCase: APIManager {
    
    let hostRoomCode: String
    
    init(hostRoomCode: String) {
        self.hostRoomCode = hostRoomCode
    }
    
    typealias ModelType = ShopResponse
    
    var methodPath: String {
        return "/shop?hostRoomCode=\(hostRoomCode)"
    }
}
