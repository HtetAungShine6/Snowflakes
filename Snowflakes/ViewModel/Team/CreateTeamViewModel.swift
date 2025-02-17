//
//  CreateTeamViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import Foundation

class CreateTeamViewModel: ObservableObject {
    
//    @Published var roomCode: String
    @Published var teamNumber: Int
    @Published var maxMembers: Int
    @Published var tokens: Int
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var teamCreationSuccess: Bool = false
    
    init(teamNumber: Int, maxMembers: Int, tokens: Int, errorMessage: String? = nil, isLoading: Bool) {
        self.teamNumber = teamNumber
        self.maxMembers = maxMembers
        self.tokens = tokens
        self.errorMessage = errorMessage
        self.isLoading = isLoading
    }
    
    func createTeam() {
        let newTeam = TeamDTO(
            teamNumber: teamNumber,
            maxMembers: maxMembers,
            tokens: tokens
        )
        
        let createTeamManager = CreateTeamUseCase()
        errorMessage = nil
        
        createTeamManager.execute(data: newTeam, getMethod: "POST", token: nil) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(_):
                    self.teamCreationSuccess = true
                case .failure(let error):
                    self.errorMessage = "Failed to create team: \(error.localizedDescription)"
//                    print(error.localizedDescription)
                }
            }
        }
    }
}
