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
    @StateObject private var getPlaygroundVM = GetPlaygroundViewModel()
//    @State private var isJoined: Bool = false
    @State private var hasNavigated = false
    
    let teams: [Team]
    
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
            waitingForHostButton
                .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getPlaygroundVM.fetchPlayground(hostRoomCode: hostRoomCode)
        })
        .onReceive(webSocketManager.$currentGameState) {  currentGameState in
            if currentGameState == "SnowFlakeCreation" {
                if !hasNavigated {
                    navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                    hasNavigated = true
                }
            }
        }
        .onChange(of: webSocketManager.timerStarted) { _, newValue in
            if newValue {
                navigationManager.currentRound = 1
            }
        }
    }
    
    private var hostRoomCode: String {
        teams.first?.hostRoomCode ?? "N/A"
    }
    
    private var playerRoomCode: String {
        teams.first?.playerRoomCode ?? "N/A"
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

    private func teamCardView(team: Team) -> some View {
        let isJoined = joinedTeams[team.teamNumber] ?? false
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
                        joinedTeams[team.teamNumber] = !(joinedTeams[team.teamNumber] ?? false)
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
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
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
}

//#Preview {
//    TeamListPlayerView(teams: [])
//        .environmentObject(NavigationManager())
//}
//#Preview {
//    TeamListView(hostRoomCode: "ABC12", playerRoomCode: "DFH123")
//}
//
