//
//  CreateLeaderboardViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import Foundation

class CreateLeaderboardViewModel: ObservableObject {
    
//    @Published var hostRoomCode: String
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    func createLeaderboard(hostRoomCode: String) {
        
        let createLeaderboardManager = LeaderboardUseCase(hostRoomCode: hostRoomCode)
        errorMessage = nil
        isLoading = true
        
        createLeaderboardManager.execute(getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let leaderboard):
                    self?.isSuccess = true
                    print("\(leaderboard.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
}
