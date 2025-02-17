//
//  ShopExchangeUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/2/25.
//

import Foundation

class ShopExchangeUseCase: APIManager {
    typealias ModelType = ShopExchangeResponse
    var methodPath: String {
        return "/shop/exchangestocks"
    }
}
