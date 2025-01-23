//
//  GetPlayerViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 21/1/2568 BE.
//

import Foundation

class GetPlayerViewModel: ObservableObject {
    
    @Published var playerInfo: PlayerResponseMessage? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String? = ""
    
    func fetchPlayer(playerName: String? = nil, roomCode: String? = nil, teamNumber: String? = nil) {
        
        isLoading = true
        errorMessage = nil
        
        let getPlayerManager = GetPlayerUseCase(
            playerName: playerName,
            roomCode: roomCode,
            teamNumber: teamNumber
        )
        
        getPlayerManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let playerResponse):
                    self?.playerInfo = playerResponse.message
                    self?.isSuccess = true
                    print("\(playerResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Game State: \(error.localizedDescription)"
                }
            }
        }
    }
}
