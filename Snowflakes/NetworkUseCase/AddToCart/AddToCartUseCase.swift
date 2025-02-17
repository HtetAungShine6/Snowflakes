//
//  AddToCartUseCase.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

import Foundation

class AddToCartUseCase: APIManager {
    typealias ModelType = AddToCartResponse
    var methodPath: String {
        return "/cart"
    }
}
