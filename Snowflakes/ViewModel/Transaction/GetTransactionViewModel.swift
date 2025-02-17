//
//  GetTransactionViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 16/2/25.
//

import Foundation

class GetTransactionViewModel: ObservableObject {
    
    @Published var transactions: [TransactionMessage] = []
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
}
