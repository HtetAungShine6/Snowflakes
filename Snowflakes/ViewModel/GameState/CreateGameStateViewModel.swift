//
//  CreateGameStateViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

import Foundation

class CreateGameStateViewModel: ObservableObject {
    
    @Published var hostRoomCode: String
    @Published var playerRoomCode: String
    @Published var currentGameState: GameState
    @Published var currentRoundNumber: Int
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", playerRoomCode: String = "", currentGameState: GameState = .TeamCreation, currentRoundNumber: Int = 0) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.currentGameState = currentGameState
        self.currentRoundNumber = currentRoundNumber
    }
    
    func createGameState() {
        
        let newGameState = GameStateDTO(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            currentGameState: currentGameState,
            currentRoundNumber: currentRoundNumber
        )
        
        let createGameStateManager = PostGameStateUseCase()
        errorMessage = nil
        isLoading = true
        
        createGameStateManager.execute(data: newGameState, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let gameState):
                    print("\(gameState.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
}
