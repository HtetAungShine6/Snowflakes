//
//  GetTeamsByRoomCode.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 22/12/2024.
//

import Foundation

class GetTeamsByRoomCode: ObservableObject {
    
    @Published var teams: [Team] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    
    //    private let getTeamsByRoomCode = GetTeamByRoomCodeUseCase()
    
    func fetchTeams(hostRoomCode: String? = nil, playerRoomCode: String? = nil) {
        
        isLoading = true
        errorMessage = nil
        
        let getTeamsByRoomCodeUseCase = GetTeamByRoomCodeUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode
        )
        
        getTeamsByRoomCodeUseCase.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let teamSearchResponse):
                    self?.teams = teamSearchResponse.message
                    print("\(teamSearchResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch teams: \(error.localizedDescription)"
                }
            }
        }
    }
}
