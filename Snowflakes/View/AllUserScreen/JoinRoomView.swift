//
//  JoinRoomView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/12/2024.
//

import SwiftUI

struct JoinRoomView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var websocketManager: WebSocketManager
    
    @ObservedObject private var getTeamsByRoomCodeVM = GetTeamsByRoomCode()
    @ObservedObject private var getGameStateVM = GetGameStateViewModel()
    @ObservedObject private var getPlayerVM = GetPlayerViewModel()
    @ObservedObject private var createPlayerVM = CreatePlayerViewModel()
    
    @State private var rotationAngle: Double = 0
    @State private var roomCode: String = ""
    @State private var userName: String = ""
    @State private var selectedRole: Role? = nil
    @State private var teams: [Team] = []
    @State private var showAlertView: Bool = false
    
    @State private var shopPeriod: Bool = false
    @State private var isSuccess: Bool = false
    
    @FocusState private var isRoomCodeFocused: Bool
    @FocusState private var isUserNameFocused: Bool
    
    enum Role {
        case host
        case player
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 20) {
                if showAlertView {
                    LoadingScreen(loadingText1: "Joining Playground...", loadingText2: "This may take a few seconds.")
                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        rotatingSnowflakeIcon(size: min(geometry.size.width * 0.9, 290))
                            .padding(.bottom, -20)
                        
                        Text("Snowflake")
                            .font(Font.custom("Futura-Medium", size: 40).weight(.medium))
                            .foregroundColor(.black)
                            .padding(.top, -10)
                        
                        VStack(spacing: 20) {
                            roleSelectionView
                            if selectedRole != nil {
                                roomCodeTextField
                                userNameTextField
                                confirmButton
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
            }
            .background(Color(UIColor.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                 isRoomCodeFocused = false
                 isUserNameFocused = false
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
            .onChange(of: getTeamsByRoomCodeVM.isLoading) { _, newValue in
                if newValue {
                    showAlertView = true
                } else {
                    showAlertView = false
                }
            }
            .onChange(of: getGameStateVM.isLoading) { _, newValue in
                if newValue {
                    showAlertView = true
                } else {
                    showAlertView = false
                }
            }
            .onReceive(getTeamsByRoomCodeVM.$teams) { teams in
                print("On Receive Teams")
                if !teams.isEmpty {
                    self.teams = teams
                    if let selectedRole = selectedRole {
                        switch selectedRole {
                        case .host:
                            navigationManager.navigateTo(Destination.teamListView(team: teams))
                        case .player:
                            navigationManager.navigateTo(Destination.teamListPlayerView(team: teams))
                        }
                    }
                } else {
                    print("Empty Teams")
                }
            }
            .onReceive(getGameStateVM.$gameState) { gameState in
                if let currentState = gameState?.currentGameState {
                    if let hostRoomCode = gameState?.hostRoomCode, let playerRoomCode = gameState?.playerRoomCode {
                        websocketManager.joinGroup(roomCode: hostRoomCode)
                        switch currentState {
                        case "TeamCreation":
                            if let selectedRole = selectedRole {
                                switch selectedRole {
                                case .host:
                                    getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: roomCode)
                                case .player:
                                    getTeamsByRoomCodeVM.fetchTeams(playerRoomCode: roomCode)
                                }
                            }
                        case "SnowFlakeCreation":
                            if let selectedRole = selectedRole {
                                switch selectedRole {
                                case .host:
                                    navigationManager.navigateTo(Destination.hostTimerView(roomCode: hostRoomCode))
                                case .player:
                                    navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                }
                            }
                        case "ShopPeriod":
                            if let selectedRole = selectedRole {
                                switch selectedRole {
                                case .host:
                                    navigationManager.navigateTo(Destination.hostShopTimerView(roomCode: hostRoomCode))
                                case .player:
                                    navigationManager.navigateTo(Destination.playerShopTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                }
                            }
                        default:
                            print("Unhandled game state: \(currentState)")
                        }
                    }
                }
            }
            .onReceive(getTeamsByRoomCodeVM.$errorMessage) { errorMessage in
                if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
        }
    }
    
    @ViewBuilder
    private func rotatingSnowflakeIcon(size: CGFloat) -> some View {
        Circle()
            .foregroundColor(.clear)
            .frame(width: size, height: size)
            .background(
                Image("snowflake_icon")
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(Circle())
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
    }
    
    private var roleSelectionView: some View {
           HStack(spacing: 20) {
               Button(action: {
                   selectedRole = .host
               }) {
                   Text("Host")
                       .font(Font.custom("Roboto-Regular", size: 18))
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(selectedRole == .host ? Color(red: 0.69, green: 0.89, blue: 0.96) : Color.gray.opacity(0.3))
                       .foregroundColor(.black)
                       .cornerRadius(10)
               }
               
               Button(action: {
                   selectedRole = .player
               }) {
                   Text("Player")
                       .font(Font.custom("Roboto-Regular", size: 18))
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(selectedRole == .player ? Color(red: 0.69, green: 0.89, blue: 0.96) : Color.gray.opacity(0.3))
                       .foregroundColor(.black)
                       .cornerRadius(10)
               }
           }
           .frame(maxWidth: .infinity)
       }

    private var roomCodeTextField: some View {
        TextField("Enter Room Code", text: $roomCode)
            .focused($isRoomCodeFocused)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: 18))
            .foregroundColor(.black)
            .keyboardType(.alphabet)
            .autocapitalization(.none)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }

    private var userNameTextField: some View {
        TextField("Enter Your Name", text: $userName)
            .focused($isUserNameFocused)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: 18))
            .foregroundColor(.black)
            .keyboardType(.default)
            .autocapitalization(.words)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }

    
    private var confirmButton: some View {
        Button {
            guard let role = selectedRole else { return }
            switch role {
            case .host:
                getGameStateVM.fetchGameState(hostRoomCode: roomCode)
            case .player:
                if let playerName = UserDefaults.standard.string(forKey: "\(roomCode)") {
                    if playerName == userName {
                        getGameStateVM.fetchGameState(playerRoomCode: roomCode)
                    }
                } else {
                    createPlayerVM.name = userName
                    createPlayerVM.playerRoomCode = roomCode
                    createPlayerVM.createPlayer()
                    UserDefaults.standard.set(userName, forKey: "\(roomCode)")
                    getGameStateVM.fetchGameState(playerRoomCode: roomCode)
                }
            }
        } label: {
            HStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.white)
                    )
                    .padding(EdgeInsets(top: 6, leading: 9.5, bottom: 6, trailing: 9.5))
                
                Text("Join a room")
                    .font(Font.custom("Lato-Regular", size: 24))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                Spacer()
            }
            .frame(width: 246, height: 74)
            .background(Color(red: 0.69, green: 0.89, blue: 0.96))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }
}


