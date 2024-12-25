//
//  CreatePlaygroundViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/12/2024.
//

import Foundation

class CreatePlaygroundViewModel: ObservableObject {
    
    @Published var hostRoomCode: String
    @Published var playerRoomCode: String
    @Published var rounds: [String: String]
    @Published var numberOfTeam: Int
    @Published var teamToken: Int
    @Published var shopToken: Int
    @Published var shop: [ShopItemViewModel]
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", playerRoomCode: String = "", rounds: [String : String] = [:], numberOfTeam: Int = 0, teamToken: Int = 0, shopToken: Int = 0, shop: [ShopItemViewModel] = []) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.rounds = rounds
        self.numberOfTeam = numberOfTeam
        self.teamToken = teamToken
        self.shopToken = shopToken
        self.shop = shop
    }
    
    func createPlayground() {
        let shopDTO = shop.map { ShopItemDTO(productName: $0.productName, price: $0.price, remainingStock: $0.remainingStock) }
        let newPlayground = PlaygroundDTO(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            rounds: rounds,
            numberOfTeam: numberOfTeam,
            teamToken: teamToken,
            shopToken: shopToken,
            shop: shopDTO
        )
        
        let createPlaygroundManager = CreatePlaygroundUseCase()
        errorMessage = nil
        isLoading = true
        isSuccess = false
        print("Before execute: \(isLoading)")
        
        createPlaygroundManager.execute(data: newPlayground, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.isSuccess = true
                    print("RESPONSE: \(data)")
                case .failure(let error):
                    self?.isSuccess = false
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                    print("\(error.localizedDescription )")
                }
            }
        }
    }
}

class ShopItemViewModel: ObservableObject, Identifiable {
    @Published var productName: String
    @Published var price: Int
    @Published var remainingStock: Int

    init(productName: String = "", price: Int = 0, remainingStock: Int = 0) {
        self.productName = productName
        self.price = price
        self.remainingStock = remainingStock
    }
}
