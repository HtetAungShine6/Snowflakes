//
//  CreatePlayerViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

import Foundation

class CreatePlayerViewModel: ObservableObject {
    
    @Published var name: String
    @Published var playerRoomCode: String
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(name: String = "", playerRoomCode: String = "") {
        self.name = name
        self.playerRoomCode = playerRoomCode
    }
    
    func createPlayer() {
        
        let newPlayer = PlayerDTO(
            name: name,
            playerRoomCode: playerRoomCode
        )
                
        let createPlayerManager = CreatePlayerUseCase()
        errorMessage = nil
        isLoading = true
        
        createPlayerManager.execute(data: newPlayer, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPlayer):
                    print("New Player Created: \(newPlayer.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
}
