//
//  GetGameStateViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

import Foundation

class GetGameStateViewModel: ObservableObject {
    
    @Published var gameState: GameStateMessage? = nil
    @Published var currentRoundNumber: Int = 0
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
                    self?.currentRoundNumber = gameStateResponse.message.currentRoundNumber
                    self?.isSuccess = true
                    print("\(gameStateResponse.message)")
                    print("Current Round Number: \(gameStateResponse.message.currentRoundNumber)")
                case .failure(let error):
                    self?.errorMessage = "The room code that you entered is incorrect."
                }
            }
        }
    }
}
