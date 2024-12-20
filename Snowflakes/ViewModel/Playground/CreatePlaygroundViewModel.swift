//
//  CreatePlaygroundViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/12/2024.
//

import Foundation

class CreatePlaygroundViewModel: ObservableObject {
    
    @Published var hostRoomCode: String
    @Published var playerRoomCode: String
    @Published var hostId: String
    @Published var rounds: [String: String]
    @Published var numberOfTeam: Int
    @Published var maxTeamMember: Int
    @Published var teamToken: Int
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(hostRoomCode: String = "", playerRoomCode: String = "", hostId: String = "", rounds: [String : String] = [:], numberOfTeam: Int = 0, maxTeamMember: Int = 0, teamToken: Int = 0) {
        self.hostRoomCode = hostRoomCode
        self.playerRoomCode = playerRoomCode
        self.hostId = hostId
        self.rounds = rounds
        self.numberOfTeam = numberOfTeam
        self.maxTeamMember = maxTeamMember
        self.teamToken = teamToken
    }
    
    func createPlayground() {
        let newPlayground = PlaygroundDTO(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            hostId: hostId,
            rounds: rounds,
            numberOfTeam: numberOfTeam,
            maxTeamMember: maxTeamMember,
            teamToken: teamToken
        )
        
        let createPlaygroundManager = CreatePlaygroundUseCase()
        errorMessage = nil
        isLoading = true
        isSuccess = false
        print("Before execute: \(isLoading)")
        
        createPlaygroundManager.execute(data: newPlayground, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.isSuccess = true
                    print("RESPONSE: \(data)")
                case .failure(let error):
                    self?.isSuccess = false
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                }
            }
        }
    }
}
