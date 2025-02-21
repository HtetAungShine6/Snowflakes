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
    @Published var currentRoundNumber: Int
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", currentGameState: GameState = .TeamCreation, currentRoundNumber: Int = 0) {
        self.hostRoomCode = hostRoomCode
        self.currentGameState = currentGameState
        self.currentRoundNumber = currentRoundNumber
    }
    
    func updateGameState() {
        
        let newGameState = UpdateGameStateDTO(
            hostRoomCode: hostRoomCode,
            currentGameState: currentGameState,
            currentRoundNumber: currentRoundNumber
        )
        
        let updateGameStateManager = UpdateGameStateUseCase()
        errorMessage = nil
        isSuccess = false
        isLoading = true
        
        updateGameStateManager.execute(data: newGameState, getMethod: "PUT", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success( _):
//                    print("\(gameState.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
//                    print(error.localizedDescription)
                }
            }
        }
    }
}
