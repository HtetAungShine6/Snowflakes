//
//  BuyImageViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/2/25.
//

import Foundation

class BuyImageViewModel: ObservableObject {
    
    @Published var isBuyingConfirmed: Bool
    @Published var hostRoomCode: String
    @Published var playerRoomCode: String
    @Published var roundNumber: Int
    @Published var teamNumber: Int
    @Published var imageUrl: String
    @Published var price: Int
    @Published var message: String = ""
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(isBuyingConfirmed: Bool = false, hostRoomCode: String = "", playerRoomCode: String = "", roundNumber: Int = 0, teamNumber: Int = 0, imageUrl: String = "", price: Int = 0) {
        self.isBuyingConfirmed = isBuyingConfirmed
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.roundNumber = roundNumber
        self.teamNumber = teamNumber
        self.imageUrl = imageUrl
        self.price = price
    }
    
    func buy() {
        
        let newBuyImage = BuyImageDTO(
            isBuyingConfirm: isBuyingConfirmed,
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            roundNumber: roundNumber,
            teamNumber: teamNumber,
            imageUrl: imageUrl,
            price: price
        )
        
        let buyImageManager = BuyImageUseCase()
        errorMessage = nil
        isLoading = true
        
        buyImageManager.execute(data: newBuyImage, getMethod: "PUT", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let buyImage):
                    self?.isSuccess = true
                    self?.message = buyImage.message
                case .failure(let error):
                    self?.errorMessage = "Failed to exchange stocks: \(error.localizedDescription)"
                }
            }
        }
    }
}
