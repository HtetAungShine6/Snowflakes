//
//  RemoveAddToCartViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import Foundation

class RemoveAddToCartViewModel: ObservableObject {
    
    @Published var message: String = ""
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    func removeCart(id: String) {
        
        let removeCartManager = RemoveCartUseCase(id: id)
        errorMessage = nil
        isLoading = true
        
        removeCartManager.execute(getMethod: "DELETE", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let removeCart):
                    self?.message = removeCart.message
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                }
            }
        }
    }
}
