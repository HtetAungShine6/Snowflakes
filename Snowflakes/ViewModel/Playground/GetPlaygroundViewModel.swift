//
//  GetPlaygroundViewModel.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 21/1/2568 BE.
//

import Foundation

class GetPlaygroundViewModel : ObservableObject {
    
    @Published var playgroundInfo : Message? = nil
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String? = ""
    
    func fetchPlayground(hostRoomCode: String) {
        
        isLoading = true
        errorMessage = nil
        
        let getPlaygroundManager = GetPlaygroundUseCase(hostRoomCode: hostRoomCode)
        
        getPlaygroundManager.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let playgroundResponse):
                    self?.playgroundInfo = playgroundResponse.message
                    self?.isSuccess = true
                    print("\(playgroundResponse)")
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch Game State: \(error.localizedDescription)"
                }
            }
        }
    }
}
