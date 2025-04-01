//
//  GetTransactionViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 16/2/25.
//

import Foundation

class GetTransactionViewModel: ObservableObject {
    
    @Published var transactions: [TransactionMessage] = []
    @Published var itemTransactions: [ItemTransitionMessage] = []
    @Published var imageTransactions: [ImageTransitionMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    @Published var isSuccess: Bool = false
    
    func fetchTransactions(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let getTeamTransaction = GetTransactionUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            roundNumber: roundNumber,
            teamNumber: teamNumber
        )
        
        getTeamTransaction.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let transactionsResponse):
                    self?.transactions = transactionsResponse.message
                    self?.isSuccess = true
                    print("\(transactionsResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch team transactions: \(error.localizedDescription)"
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchItemTransactions(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let getItemTransaction = GetItemTransitionUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            roundNumber: roundNumber,
            teamNumber: teamNumber
        )
        
        getItemTransaction.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let transactionsResponse):
                    self?.itemTransactions = transactionsResponse.message
                    self?.isSuccess = true
                    print("\(transactionsResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch item transactions: \(error.localizedDescription)"
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchImageTransactions(hostRoomCode: String? = nil, playerRoomCode: String? = nil, roundNumber: Int, teamNumber: Int) {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let getImageTransaction = GetImageTransitionUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            roundNumber: roundNumber,
            teamNumber: teamNumber
        )
        
        getImageTransaction.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let transactionsResponse):
                    self?.imageTransactions = transactionsResponse.message
                    self?.isSuccess = true
                    print("\(transactionsResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch image transactions: \(error.localizedDescription)"
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}
