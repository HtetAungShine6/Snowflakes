//
//  PlayerTeamSearchViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 5/2/25.
//

//import Foundation
//
//class PlayerTeamSearchViewModel: ObservableObject {
//    
//    @Published var playerTeamInfo: PlayerTeamSearchMessage? = nil
//    @Published var errorMessage: String? = nil
//    @Published var isLoading: String? = nil
//    
//    func getPlayerTeamInfo(playerName: String, roomCode: String, teamNumber: String) {
//        errorMessage = nil
//        let getEvent = FindEventForUnit(id: id)
//        getEvent.execute(getMethod: "GET", token: nil) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let eventResult):
//                    self.eventUnit = eventResult.message
//                case .failure(_):
//                    self.errorMessage = "Failed to get event for a unit."
//                }
//            }
//        }
//    }
//}
