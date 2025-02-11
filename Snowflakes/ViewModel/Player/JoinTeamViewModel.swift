//
//  JoinTeamViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 3/2/25.
//

import Foundation

class JoinTeamViewModel: ObservableObject {
    
    @Published var playerName: String
    @Published var teamNumber: Int
    @Published var playerRoomCode: String
    @Published var status: String
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init(playerName: String = "", teamNumber: Int = 0, playerRoomCode: String = "", status: String = "") {
        self.playerName = playerName
        self.teamNumber = teamNumber
        self.playerRoomCode = playerRoomCode
        self.status = status
    }
    
    func join() {
        
        let newJoinedTeam = PlayerTeamJoinDTO(
            playerName: playerName,
            teamNumber: teamNumber,
            playerRoomCode: playerRoomCode,
            status: status
        )
                
        let joinTeam = JoinTeamUseCase()
        errorMessage = nil
        isLoading = true
        
        joinTeam.execute(data: newJoinedTeam, getMethod: "PUT", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let joinedTeam):
//                    print("New Team Joined: \(joinedTeam.message)")
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = "Failded to join team: \(error.localizedDescription)"
//                    print(error.localizedDescription)
                }
            }
        }
    }
}
