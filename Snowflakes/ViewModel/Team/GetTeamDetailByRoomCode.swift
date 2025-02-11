//
//  GetTeamDetailByRoomCode.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 9/2/25.
//

import Foundation

class GetTeamDetailByRoomCode: ObservableObject {
    
    @Published var team: Team? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    @Published var isSuccess: Bool = false
    
    func fetchTeams(hostRoomCode: String? = nil, playerRoomCode: String? = nil, teamNumber: Int = 0) {
        
        self.isLoading = true
        self.errorMessage = nil
        
        let getTeamsByRoomCodeUseCase = GetTeamDetailByRoomCodeUseCase(
            hostRoomCode: hostRoomCode,
            playerRoomCode: playerRoomCode,
            teamNumber: teamNumber
        )
        
        getTeamsByRoomCodeUseCase.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let teamDetailResponse):
                    self?.team = teamDetailResponse.message
                    self?.isSuccess = true
//                    print("Get TeamDetail By RoomCode:\(teamDetailResponse.message)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch teams: \(error.localizedDescription)"
                }
            }
        }
    }
}
