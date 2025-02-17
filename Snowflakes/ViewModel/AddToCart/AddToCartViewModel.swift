//
//  AddToCartViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

import Foundation

class AddToCartViewModel: ObservableObject {
    
    @Published var hostRoomCode: String = ""
    @Published var playerRoomCode: String = ""
    @Published var productName: String = ""
    @Published var price: Int = 0
    @Published var quantity: Int = 0
    @Published var teamNumber: Int = 0
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", playerRoomCode: String = "", productName: String = "", price: Int = 0, quantity: Int = 0, teamNumber: Int = 0) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.productName = productName
        self.price = price
        self.quantity = quantity
        self.teamNumber = teamNumber
    }
    
    func addToCart() {
        
        let newAddToCart = AddToCartDTO(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            productName: productName,
            price: price,
            quantity: quantity,
            teamNumber: teamNumber
        )
        
        let addToCartManager = AddToCartUseCase()
        errorMessage = nil
        isLoading = true
        
        addToCartManager.execute(data: newAddToCart, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let addToCartItem):
                    print("\(addToCartItem.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
//                    print(error.localizedDescription)
                }
            }
        }
    }
}
