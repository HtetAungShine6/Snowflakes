//
//  BuyImageUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/2/25.
//

import Foundation

class BuyImageUseCase: APIManager {
    typealias ModelType = BuyImageResponse
    var methodPath: String {
        return "/shop/buyimage"
    }
}
