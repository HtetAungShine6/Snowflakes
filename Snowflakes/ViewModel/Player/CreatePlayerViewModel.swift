//
//  CreatePlayerViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/01/2025.
//

import Foundation

class CreatePlayerViewModel: ObservableObject {
    
    @Published var name: String
    @Published var roomCode: String
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(name: String = "", roomCode: String = "") {
        self.name = name
        self.roomCode = roomCode
    }
    
    func createPlayer() {
        
        let newPlayer = PlayerDTO(
            name: name,
            roomCode: roomCode
        )
                
        let createPlayerManager = CreatePlayerUseCase()
        errorMessage = nil
        isLoading = true
        
        createPlayerManager.execute(data: newPlayer, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPlayer):
                    print("\(newPlayer.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
}
