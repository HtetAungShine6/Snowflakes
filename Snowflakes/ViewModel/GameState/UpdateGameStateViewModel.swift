//
//  UpdateGameStateViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/01/2025.
//

import Foundation

class UpdateGameStateViewModel: ObservableObject {
    
    @Published var hostRoomCode: String
    @Published var currentGameState: GameState
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", currentGameState: GameState = .TeamCreation) {
        self.hostRoomCode = hostRoomCode
        self.currentGameState = currentGameState
    }
    
    func updateGameState() {
        
        let newGameState = UpdateGameStateDTO(
            hostRoomCode: hostRoomCode,
            currentGameState: currentGameState
        )
        
        let updateGameStateManager = UpdateGameStateUseCase()
        errorMessage = nil
        isLoading = true
        
        updateGameStateManager.execute(data: newGameState, getMethod: "PUT", token: nil) { [weak self] result in
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