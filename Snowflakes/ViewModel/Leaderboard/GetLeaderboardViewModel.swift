//
//  GetLeaderboardViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import Foundation

class GetLeaderboardViewModel: ObservableObject {
    
    @Published var leaderboard: [LeaderboardMessage] = []
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    func fetchLeaderboard(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        
        let getLeaderboardManager = LeaderboardUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode
        )
        
        errorMessage = nil
        isLoading = true
        
        getLeaderboardManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let leaderboard):
                    self?.leaderboard = leaderboard.message
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
