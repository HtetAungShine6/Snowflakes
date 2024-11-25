//
//  CreateTeamView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct CreateTeamView: View {
    @State private var teamNumber: Int = 0
    @State private var maxMembers: Int = 0
    @State private var tokens: Int = 0
    
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var teamCreationSuccess: Bool = false
    
    @ObservedObject var VM: CreateTeamViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create Team")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Enter Team Number", value: $teamNumber, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            TextField("Enter Max Members", value: $maxMembers, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            TextField("Enter Tokens", value: $tokens, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            if isLoading {
                ProgressView()
                    .padding()
            }
            
            Button(action: {
                if isInputValid() {
                    VM.teamNumber = teamNumber
                    VM.maxMembers = maxMembers
                    VM.tokens = tokens
                    VM.createTeam()
                }
            }) {
                Text("Create Team")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if teamCreationSuccess {
                Text("Team created successfully!")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Validation
    private func isInputValid() -> Bool {
        guard teamNumber > 0 else {
            errorMessage = "Team Number must be greater than 0."
            return false
        }
        guard maxMembers > 0 else {
            errorMessage = "Max Members must be greater than 0."
            return false
        }
        guard tokens >= 0 else {
            errorMessage = "Tokens cannot be negative."
            return false
        }
        errorMessage = nil
        return true
    }
    
//    // MARK: - API Call
//    private func createTeam() {
//        isLoading = true
//        errorMessage = nil
//        
//        let newTeam = TeamDTO(
//            teamNumber: teamNumber,
//            maxMembers: maxMembers,
//            tokens: tokens
//        )
//        
//        let createTeamManager = CreateTeamUseCase()
//        createTeamManager.execute(data: newTeam, getMethod: "POST", token: nil) { result in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch result {
//                case .success(_):
//                    self.teamCreationSuccess = true
//                case .failure(let error):
//                    self.errorMessage = "Failed to create team: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
}

//struct CreateTeamView_Previews: PreviewProvider {
//    static var previews: some View {
////        CreateTeamView()
//    }
//}
