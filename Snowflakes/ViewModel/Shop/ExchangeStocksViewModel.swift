//
//  Untitled.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/2/25.
//

import Foundation

class ExchangeStocksViewModel: ObservableObject {
    
    @Published var roundNumber: Int
    @Published var cartIds: [String]
    @Published var playerRoomCode: String
    @Published var hostRoomCode: String
    @Published var teamNumber: Int
    @Published var products: [ProductDTO]
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(roundNumber: Int = 0, cartIds: [String] = [], playerRoomCode: String = "", hostRoomCode: String = "", teamNumber: Int = 0, products: [ProductDTO] = []) {
        self.roundNumber = roundNumber
        self.cartIds = cartIds
        self.playerRoomCode = playerRoomCode
        self.hostRoomCode = hostRoomCode
        self.teamNumber = teamNumber
        self.products = products
    }
    
    func exchangeStocks() {
        let newExchangeStocks = ShopExchangeDTO(
            roundNumber: roundNumber,
            cartIds: cartIds,
            playerRoomCode: playerRoomCode,
            hostRoomCode: hostRoomCode,
            teamNumber: teamNumber,
            products: products
        )
        
        let exchangeStocksManager = ShopExchangeUseCase()
        errorMessage = nil
        isLoading = true
        
        exchangeStocksManager.execute(data: newExchangeStocks, getMethod: "PUT", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let exchangeStockItem):
                    print("Exchange Stocks Successful: \(exchangeStockItem.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to exchange stocks: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
}
