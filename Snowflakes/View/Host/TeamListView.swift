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
    
    @State private var showAlertView: Bool = false
    
    let teams: [Team]
    
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
                        Text("Updating your Playground...")
                            .font(.custom("Lato-Bold", size: 20))
                            .foregroundColor(.white)
                        Text("This may take a few seconds.")
                            .font(.custom("Lato-Regular", size: 16))
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
                    startPlaygroundButton
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Action for the back button
                            navigationManager.pop()
                            webSocketManager.disconnect()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    webSocketManager.connect()
                }
                .onChange(of: webSocketManager.isConnected) { _, isConnected in
                    if isConnected {
                        // join
                        webSocketManager.joinGroup(roomCode: hostRoomCode)
                    }
                }
            }
        }
//        .onChange(of: updateGameStateViewModel.isLoading) { _, newValue in
//            if newValue {
//                showAlertView = true
//            } else {
//                showAlertView = false
//            }
//        }
//        .onChange(of: updateGameStateViewModel.isSuccess) { _, newValue in
//            if newValue {
//                navigationManager.navigateTo(Destination.gameView)
//                navigationManager.isShopTime = false
//            }
//        }
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack(alignment: .leading) {
                Text("Host Room Code: \(hostRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
                Text("Player Room Code: \(playerRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
            }
        }
        .padding(.horizontal)
    }
    
    private var hostRoomCode: String {
        teams.first?.hostRoomCode ?? "N/A"
    }
    
    private var playerRoomCode: String {
        teams.first?.playerRoomCode ?? "N/A"
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members?.count ?? 0)
        }
    }
    
    private var totalNumberHostPlayer: some View{
        HStack {
            Text("Player: \(totalPlayerCount)") //call api
                .font(.custom("Lato-Medium", size: 15))
//            Text("Host: 2") //call api
//                .font(.custom("Lato-Medium", size: 15))
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Text("(\(team.members?.count ?? 0) Players)")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundStyle(Color.gray)
            }
            
            HStack(spacing: 10) {
                ForEach(team.teamStocks, id: \.self) { itemName in
                    VStack {
                        Image("\(itemName.productName)")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(itemName.remainingStock)")
                            .font(.custom("Lato-Regular", size: 16))
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
                        .font(.custom("Lato-Regular", size: 16))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
                if team.members != nil {
                    Text("\(String(describing: team.members?.joined(separator: ", ")))")
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
    
    private var startPlaygroundButton: some View {
        Button(action: {
            //            if let hostRoomCode = teams.first?.hostRoomCode {
            //                updateGameStateViewModel.hostRoomCode = hostRoomCode
            //                updateGameStateViewModel.currentGameState = .SnowFlakeCreation
            //                updateGameStateViewModel.updateGameState()
            //            }
            if let hostRoomCode = teams.first?.hostRoomCode {
                navigationManager.roomCode = hostRoomCode
                navigationManager.navigateTo(Destination.gameView, roomCode: hostRoomCode)
            }
            navigationManager.isShopTime = false
        }) {
            Text("Start a playground")
                .font(.custom("Lato-Bold", size: 20))
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.frostBlue)
                .foregroundStyle(.black)
                .cornerRadius(10)
        }
    }
}

//#Preview {
//    TeamListView(hostRoomCode: "ABC12", playerRoomCode: "DFH123")
//}
//
