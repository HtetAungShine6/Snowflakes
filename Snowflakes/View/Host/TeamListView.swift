//
//  TeamListView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/11/2024.
//

import SwiftUI

struct TeamListView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject private var webSocketManager: WebSocketManager
    
    @StateObject private var updateGameStateViewModel = UpdateGameStateViewModel()
    @StateObject private var getPlaygroundVM = GetPlaygroundViewModel()
    @StateObject private var getTeamsByRoomCodeVM = GetTeamsByRoomCode()
    
    @State private var showAlertView: Bool = false
    @State private var hasNavigated = false
    @State private var teams: [Team] = []
    
    let hostRoomCode: String
    
    var body: some View {

        VStack {
            if showAlertView {
                ZStack {
                    AppColors.frostBlue.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                        Text("Loading your Playground...")
                            .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                            .foregroundColor(.white)
                        Text("This may take a few seconds.")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(40)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black).opacity(0.5))
                }
            } else {
                VStack(alignment: .leading) {
                    navBar
                    totalNumberHostPlayer
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
                        getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: hostRoomCode)
                    }
                    startPlaygroundButton
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
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getPlaygroundVM.fetchPlayground(hostRoomCode: hostRoomCode)
            getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: hostRoomCode)
            hasNavigated = false
        })
        .onReceive(webSocketManager.$currentGameState) {  currentGameState in
            if currentGameState == "SnowFlakeCreation" {
                if !hasNavigated {
                    navigationManager.navigateTo(Destination.hostTimerView(roomCode: hostRoomCode))
                    hasNavigated = true
                }
            }
        }
        .onReceive(getTeamsByRoomCodeVM.$teams) { teams in
            if !teams.isEmpty {
                self.teams = teams
            }
        }
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack(alignment: .leading) {
                Text("Host Room Code: \(hostRoomCode)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                Text("Player Room Code: \(playerRoomCode)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
            }
        }
        .padding(.horizontal)
    }
    
    private var playerRoomCode: String {
        teams.first?.playerRoomCode ?? "N/A"
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members.count)
        }
    }
    
    private var totalNumberHostPlayer: some View{
        HStack {
            Text("Player: \(totalPlayerCount)") //call api
                .font(.custom("Lato-Medium", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                Text("(\(team.members.count) Players)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                    .foregroundStyle(Color.gray)
            }
            
            HStack(spacing: 10) {
                ForEach(team.teamStocks, id: \.self) { itemName in
                    VStack {
                        Image("\(itemName.productName)")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(itemName.remainingStock)")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                            .foregroundStyle(Color.gray)
                    }
                }
                Spacer()
                HStack {
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
                if !team.members.isEmpty {
                    Text("\(String(describing: team.members.joined(separator: ", ")))")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                } else {
                    Text("No Member Here Yet")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary))
    }
    
    private var startPlaygroundButton: some View {
        Button(action: {
            guard let rounds = getPlaygroundVM.playgroundInfo?.rounds else {
                print("No rounds available.")
                return
            }
            
            if let roundOne = rounds.first(where: { $0.roundNumber == 1 }) {
                let currentRoundDuration = roundOne.duration
                print("Duration for Round 1: \(currentRoundDuration)")
                webSocketManager.createTimer(roomCode: hostRoomCode, socketMessage: currentRoundDuration, gameState: "SnowFlakeCreation")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    webSocketManager.startCountdown(roomCode: hostRoomCode)
                    webSocketManager.pauseCountdown(roomCode: hostRoomCode)
                }
                DispatchQueue.main.async {
                    updateGameStateViewModel.hostRoomCode = hostRoomCode
                    updateGameStateViewModel.currentGameState = GameState.SnowFlakeCreation
                    updateGameStateViewModel.currentRoundNumber = 1
                    updateGameStateViewModel.updateGameState()
                }
            } else {
                print("Round 1 not found.")
            }
        }) {
            Text("Start a playground")
                .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.frostBlue)
                .foregroundStyle(.black)
                .cornerRadius(10)
        }
    }
}

//#Preview {
//    TeamListView(hostRoomCode: "ABCDEF")
//}
