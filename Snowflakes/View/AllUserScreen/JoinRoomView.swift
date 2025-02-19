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
    
    @ObservedObject private var getGameStateVM = GetGameStateViewModel()
    @ObservedObject private var getPlayerVM = GetPlayerViewModel()
    @ObservedObject private var createPlayerVM = CreatePlayerViewModel()
    
    @State private var rotationAngle: Double = 0
    @State private var roomCode: String = ""
    @State private var userName: String = ""
    @State private var selectedRole: Role? = nil
    @State private var teams: [Team] = []
    @State private var showAlertView: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @State private var shopPeriod: Bool = false
    @State private var isSuccess: Bool = false
    @FocusState private var isRoomCodeFocused: Bool
    @FocusState private var isUserNameFocused: Bool
    
    @State private var keyboardIsVisible: Bool = false
    
    
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
                        
                        if !keyboardIsVisible {
                            rotatingSnowflakeIcon(size: min(geometry.size.width * 0.9, 290))
                                .padding(.bottom, -20)
                            
                            Text("Snowflake")
                                .font(Font.custom("Futura-Medium", size: UIFont.preferredFont(forTextStyle: .extraLargeTitle).pointSize).weight(.medium))
                                .foregroundColor(.black)
                                .padding(.top, -10)
                        }
                        
                        VStack(spacing: 20) {
                            roleSelectionView
                            if selectedRole != nil {
                                VStack(spacing: 10) {
                                    roomCodeTextField
                                    if selectedRole == .player {
                                        userNameTextField
                                    }
                                    confirmButton
                                }
                                .opacity(selectedRole != nil ? 1 : 0)
                                .scaleEffect(selectedRole != nil ? 1 : 0.95)
                                .animation(.easeInOut(duration: 0.7), value: selectedRole)
                            }
                        }
                        .padding(.top, 10)
                        .animation(.easeInOut(duration: 0.7), value: keyboardIsVisible)
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
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                keyboardIsVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardIsVisible = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigationManager.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onChange(of: getGameStateVM.isLoading) { _, newValue in
                showAlertView = newValue
            }
            .onChange(of: getGameStateVM.errorMessage) { _, newErrorMessage in
                if let message = newErrorMessage, !message.isEmpty {
                    alertTitle = "Error"
                    alertMessage = message
                    showAlert = true
                }
            }
            .onReceive(getGameStateVM.$gameState) { gameState in
                   if let currentState = gameState?.currentGameState {
                       if let hostRoomCode = gameState?.hostRoomCode, let playerRoomCode = gameState?.playerRoomCode {
                           DispatchQueue.main.async {
                               websocketManager.joinGroup(roomCode: hostRoomCode)
                           }
                           switch currentState {
                           case "TeamCreation":
                               if let selectedRole = selectedRole {
                                   switch selectedRole {
                                   case .host:
                                       navigationManager.navigateTo(Destination.teamListView(hostRoomCode: hostRoomCode))
                                   case .player:
                                       UserDefaults.standard.set(userName, forKey: "\(roomCode)")
                                       navigationManager.navigateTo(Destination.teamListPlayerView(playerRoomCode: playerRoomCode))
                                   }
                               }
                           case "SnowFlakeCreation":
                               if let selectedRole = selectedRole {
                                   switch selectedRole {
                                   case .host:
                                       navigationManager.navigateTo(Destination.hostTimerView(roomCode: hostRoomCode))
                                   case .player:
                                       if UserDefaults.standard.string(forKey: "TeamDetail-\(playerRoomCode)") != nil {
                                           navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                       } else {
                                           showAlert = true
                                           alertTitle = "Team Number cannot be found for this username and room code."
                                           alertMessage = "Cannot join room. The game has already begun."
                                       }
                                   }
                               }
                           case "ShopPeriod":
                               if let selectedRole = selectedRole {
                                   switch selectedRole {
                                   case .host:
                                       navigationManager.navigateTo(Destination.hostShopTimerView(roomCode: hostRoomCode))
                                   case .player:
                                       if UserDefaults.standard.string(forKey: "TeamDetail-\(playerRoomCode)") != nil {
                                           navigationManager.navigateTo(Destination.playerShopTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                       } else {
                                           showAlert = true
                                           alertTitle = "Team Number cannot be found for this username and room code."
                                           alertMessage = "Cannot join room. The game has already begun."
                                       }
                                   }
                               }
                           case "Leaderboard":
                               if let selectedRole = selectedRole{
                                   switch selectedRole {
                                   case .host:
                                       navigationManager.navigateTo(Destination.leaderboard(roomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                   case .player:
                                       if UserDefaults.standard.string(forKey: "TeamDetail-\(playerRoomCode)") != nil {
                                           navigationManager.navigateTo(Destination.leaderboard(roomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                                       } else {
                                           showAlert = true
                                           alertTitle = "Team Number cannot be found for this username and room code."
                                           alertMessage = "Cannot join room. The game has already finished."
                                       }
                                   }
                               }
                           default:
                               print("Unhandled game state: \(currentState)")
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func navigateToAppropriateView(roomCode: String, playerRoomCode: String) {
        guard let selectedRole = selectedRole else { return }
        switch selectedRole {
        case .host:
            navigationManager.navigateTo(Destination.hostTimerView(roomCode: roomCode))
        case .player:
            navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: roomCode, playerRoomCode: playerRoomCode))
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
                    .font(Font.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedRole == .host ? Color(red: 0.69, green: 0.89, blue: 0.96) : Color.gray.opacity(0.3))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
            
            Button(action: {
                selectedRole = .player
            }) {
                Text("Player")
                    .font(Font.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedRole == .player ? Color(red: 0.69, green: 0.89, blue: 0.96) : Color.gray.opacity(0.3))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var roomCodeTextField: some View {
        TextField("Enter Room Code", text: $roomCode)
            .focused($isRoomCodeFocused)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
            .foregroundColor(.primary)
            .keyboardType(.alphabet)
            .autocapitalization(.none)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }
    
    private var userNameTextField: some View {
        TextField("Enter Your Name", text: $userName)
            .focused($isUserNameFocused)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
            .foregroundColor(.primary)
            .keyboardType(.default)
            .autocapitalization(.words)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }
    
    private var confirmButton: some View {
        Button {
            guard let role = selectedRole else { return }

            if roomCode.isEmpty {
                alertTitle = "Error"
                alertMessage = "Room Code cannot be empty!"
                showAlert = true
                return
            }

            if !isValidRoomCode(roomCode) {
                alertTitle = "Error"
                alertMessage = "Invalid Room Code!"
                showAlert = true
                return
            }

            if selectedRole == .player && userName.isEmpty {
                alertTitle = "Error"
                alertMessage = "Username cannot be empty!"
                showAlert = true
                return
            }

            switch role {
            case .host:
                getGameStateVM.fetchGameState(hostRoomCode: roomCode)
            case .player:
                if let playerName = UserDefaults.standard.string(forKey: "\(roomCode)") {
                    if playerName == userName {
                        getGameStateVM.fetchGameState(playerRoomCode: roomCode)
                    } else {
                        alertTitle = "Error"
                        alertMessage = "Username doesn't match for this room!"
                        showAlert = true
                    }
                } else {
                    createPlayerVM.name = userName
                    createPlayerVM.playerRoomCode = roomCode
                    createPlayerVM.createPlayer()
//                    UserDefaults.standard.set(userName, forKey: "\(roomCode)")
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
                    .font(Font.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .title2).pointSize))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                Spacer()
            }
            .frame(width: 246, height: 74)
            .background(Color(red: 0.69, green: 0.89, blue: 0.96))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }

    private func isValidRoomCode(_ code: String) -> Bool {
        // Check if the code is valid (e.g., a specific length, alphanumeric)
        return code.count == 6 && code.range(of: "^[a-zA-Z0-9]+$", options: .regularExpression) != nil
    }
}
