//
//  CartManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/2/25.
//

import SwiftUI

class CartManager: ObservableObject {
    @Published var cartItems: [(name: String, price: Int, quantity: Int)] = []
    
    func addItem(name: String, price: Int, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.name == name }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append((name, price, quantity)) 
        }
    }
}
