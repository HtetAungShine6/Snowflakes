//
//  ShopItemViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 25/12/2024.
//

import Foundation

class ShopItemViewModel: ObservableObject {
    @Published var productName: String
    @Published var price: Int
    @Published var remainingStock: Int

    init(productName: String = "", price: Int = 0, remainingStock: Int = 0) {
        self.productName = productName
        self.price = price
        self.remainingStock = remainingStock
    }
}
