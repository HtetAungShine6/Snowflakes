//
//  TeamListPlayerView.swift
//  Snowflakes
//
//  Created by Hein Thant on 23/11/2567 BE.
//

import SwiftUI

struct TeamListPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var joinedTeams: [Int: Bool] = [:]
    @State private var joinedTeamNumber: Int?
    @StateObject private var joinTeamVM = JoinTeamViewModel()
    @StateObject private var getTeamsByRoomCodeVM = GetTeamsByRoomCode()
    @State private var teams: [Team] = []
    @State private var hasNavigated: Bool = false
    
    let playerRoomCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            navBar
            totalNumberPlayers
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(teams, id: \.teamNumber) { team in
                        teamCardView(team: team)
                            .padding(.bottom, 8)
                    }
                }
                .padding()
            }
            .refreshable {
                refreshTeams()
            }
            
            waitingForHostButton
                .padding()
        }
        .onAppear {
            getTeamsByRoomCodeVM.fetchTeams(playerRoomCode: playerRoomCode)
        }
        .onReceive(getTeamsByRoomCodeVM.$teams) { newTeams in
            if !newTeams.isEmpty {
                self.teams = newTeams
                updateJoinedTeams()
            }
        }
        .onReceive(webSocketManager.$currentGameState) {  currentGameState in
            if currentGameState == "SnowFlakeCreation" {
                if !hasNavigated {
                    navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                    hasNavigated = true
                }
            }
        }
    }
    
    private var hostRoomCode: String {
        teams.first?.hostRoomCode ?? "N/A"
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members?.count ?? 0)
        }
    }
    
    private var totalNumberPlayers: some View {
        HStack {
            Text("Player: \(totalPlayerCount)")
                .font(.custom("Lato-Medium", size: 15))
        }
        .padding(.horizontal)
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            if let roomCode = teams.first?.playerRoomCode {
                Text("Room Code: \(roomCode)")
                    .font(.custom("Lato-Regular", size: 16))
            }
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: Team) -> some View {
        let isJoined = joinedTeams[team.teamNumber] ?? false
        let isDisabled = joinedTeamNumber != nil && joinedTeamNumber != team.teamNumber
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Text("(\(team.members?.count ?? 0) Players)")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundStyle(Color.gray)
                Spacer()
                
                Button(action: {
                    withAnimation {
                        toggleTeamMembership(for: team)
                    }
                }) {
                    Text(isJoined ? "Leave" : "Join")
                        .font(.custom("Lato-Regular", size: 16))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(.white)
                        .foregroundColor(isJoined ? .red : .green)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(isDisabled ? Color.gray : Color.black, lineWidth: 1)
                        )
                }
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.5 : 1.0)
            }
            
            HStack(spacing: 10) {
                Spacer()
                HStack {
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: 16))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
                if let members = team.members {
                    Text("\(members.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                } else {
                    Text("No Member Here")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary))
    }
    
    private var waitingForHostButton: some View {
        HStack {
            Spacer()
            Text("Waiting for host to start..")
                .font(Font.custom("Lato-Regular", size: 20).weight(.medium))
                .foregroundColor(.black)
            Spacer()
        }
    }
    
    // MARK: - Functions
    
    private func refreshTeams() {
        getTeamsByRoomCodeVM.fetchTeams(playerRoomCode: playerRoomCode)
    }
    
    private func updateJoinedTeams() {
        if let playerName = UserDefaults.standard.string(forKey: "\(playerRoomCode)") {
            for team in teams {
                if team.members?.contains(playerName) == true {
                    joinedTeams[team.teamNumber] = true
                    joinedTeamNumber = team.teamNumber
                }
            }
        }
    }
    
    private func toggleTeamMembership(for team: Team) {
        guard let playerName = UserDefaults.standard.string(forKey: "\(playerRoomCode)") else {
            return
        }
        let isCurrentlyJoined = joinedTeams[team.teamNumber] ?? false
        
        if isCurrentlyJoined {
            joinedTeams[team.teamNumber] = false
            joinedTeamNumber = nil
            
            joinTeamVM.teamNumber = team.teamNumber
            joinTeamVM.playerRoomCode = team.playerRoomCode
            joinTeamVM.status = "remove"
            joinTeamVM.playerName = playerName
            joinTeamVM.join()
        } else {
            joinedTeams.keys.forEach { joinedTeams[$0] = false }
            joinedTeams[team.teamNumber] = true
            joinedTeamNumber = team.teamNumber
            
            joinTeamVM.teamNumber = team.teamNumber
            joinTeamVM.playerRoomCode = team.playerRoomCode
            joinTeamVM.status = "add"
            joinTeamVM.playerName = playerName
            joinTeamVM.join()
        }
    }
}
