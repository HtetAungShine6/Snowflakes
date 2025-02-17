//
//  RemoveCartUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

class RemoveCartUseCase: APIManager {
    
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    typealias ModelType = RemoveAddToCartResponse
    
    var methodPath: String {
        return "/cart/\(id)"
    }
}
