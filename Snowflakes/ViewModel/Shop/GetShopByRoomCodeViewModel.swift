//
//  GetShopByRoomCodeViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 8/2/25.
//

import Foundation

class GetShopByRoomCodeViewModel: ObservableObject {
    
    @Published var shopMessageResponse: ShopMessageResponse? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String? = ""
    
    func fetchShop(hostRoomCode: String) {
        
        isLoading = true
        errorMessage = nil
        
        let getShopManager = GetShopUseCase(
            hostRoomCode: hostRoomCode
        )
        
        getShopManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let shopResponse):
                    self?.shopMessageResponse = shopResponse.message
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Game State: \(error.localizedDescription)"
                }
            }
        }
    }
}
