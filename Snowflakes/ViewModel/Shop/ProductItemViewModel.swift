//
//  ProductItemViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/2/25.
//

import Foundation

class ProductItemViewModel: ObservableObject {
    @Published var productName: String
    @Published var quantity: Int

    init(productName: String = "", quantity: Int = 0) {
        self.productName = productName
        self.quantity = quantity
    }
}
