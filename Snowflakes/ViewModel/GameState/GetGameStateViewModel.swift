//
//  GetGameStateViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

import Foundation

class GetGameStateViewModel: ObservableObject {
    
    @Published var gameState: GameStateMessage? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String? = ""
    
    func fetchGameState(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        
        isLoading = true
        errorMessage = nil
        
        let getGameStateManager = GetGameStateUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode
        )
        
        getGameStateManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let gameStateResponse):
                    self?.gameState = gameStateResponse.message
                    self?.isSuccess = true
                    print("\(gameStateResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Game State: \(error.localizedDescription)"
                }
            }
        }
    }
}
