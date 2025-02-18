//
//  GetAddToCartViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 14/2/25.
//

import Foundation

class GetAddToCartViewModel: ObservableObject {
    
    @Published var addToCartItems: [AddToCartResponseMessage] = []
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String? = ""
    
    func fetchItems(hostRoomCode: String? = nil, playerRoomCode: String? = nil, teamNumber: Int) {
        
        isLoading = true
        errorMessage = nil
        
        let getAddToCartManager = GetAddToCartUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            teamNumber: teamNumber
        )
        
        getAddToCartManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let addToCart):
                    self?.addToCartItems = addToCart.message
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Cannot get Add To Cart Items: \(error.localizedDescription)"
                }
            }
        }
    }
}
