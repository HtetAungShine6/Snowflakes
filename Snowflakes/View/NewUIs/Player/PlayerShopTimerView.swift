//
//  PlayerShopTimerView.swift
//  Snowflakes
//
//  Created by Hein Thant on 26/1/2568 BE.
//

import SwiftUI
 
struct PlayerShopTimerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject private var webSocketManager: WebSocketManager
    
    @StateObject private var getPlaygroundVM = GetPlaygroundViewModel()
    @StateObject private var updateGameStateViewModel = UpdateGameStateViewModel()
    @StateObject private var getGameStateViewModel = GetGameStateViewModel()
    
    @State private var timerValueFromSocket: String = ""
    @State private var sendMessageText: String = ""
    @State private var isPlaying: Bool = false
    @State private var isButtonDisabled = false
    @State private var hasNavigated: Bool = false
    @State private var hasStartedCountdown: Bool = false
    
    let playerRoomCode: String
    let hostRoomCode: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                VStack(spacing: 20) {
                    navBar
                        .padding(.horizontal)
                        .padding(.top, geometry.safeAreaInsets.top)
                    
                    VStack(spacing: 15) {
                        timer
                        timerImage
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    
//                    descriptionText
                    hostMessage
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.top, 150)
                }
                .padding(.top, -geometry.safeAreaInsets.top)
                
            }
        }
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
        .navigationBarBackButtonHidden()
        .onAppear {
            getPlaygroundVM.fetchPlayground(hostRoomCode: hostRoomCode)
            getGameStateViewModel.fetchGameState(playerRoomCode: playerRoomCode)
            hasNavigated = false
        }
        .onChange(of: getPlaygroundVM.isLoading, { _, newValue in
            if newValue {
                // show alert
            } else {
                // hide alert
            }
        })
        .onReceive(webSocketManager.$currentGameState) { currentGameState in
            if currentGameState == "SnowFlakeCreation" && !hasNavigated {
                if getGameStateViewModel.currentRoundNumber == navigationManager.totalRound {
                    navigationManager.navigateTo(Destination.leaderboard(roomCode: hostRoomCode))
                } else {
                    getGameStateViewModel.currentRoundNumber += 1
                    navigationManager.navigateTo(Destination.playerTimerView(hostRoomCode: hostRoomCode, playerRoomCode: playerRoomCode))
                    hasNavigated = true
                }
            }
        }
    }
    
    private var navBar: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Snowflake")
                    .font(.custom("Montserrat-Medium", size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                    .foregroundStyle(Color.black)
                
                Text("Round (\(getGameStateViewModel.currentRoundNumber)/\(navigationManager.totalRound))")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Button {
                navigationManager.navigateTo(Destination.shopDetailPlayerView(playerRoomCode: playerRoomCode, roundNumber: getGameStateViewModel.currentRoundNumber))
            }label: {
                Image("shop2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
        }
        .padding(.horizontal)
    }
    
    private var timer: some View {
        HStack {
            Spacer()
            if !webSocketManager.countdown.isEmpty {
                Text("\(webSocketManager.countdown)")
                    .font(.custom("Montserrat-Medium", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize))
                    .foregroundColor(.black)
            } else {
                Text("00:00")
                    .font(.custom("Montserrat-Medium", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize))
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }
    
    private var timerImage: some View {
        Image("Shop 1")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 226)
    }
    
    private var descriptionText: some View {
        VStack {
            (Text("It is time to ")
                .font(.custom("Roboto-Regular", size: 36))
                .foregroundColor(.primary) +
             Text("sell")
                .font(.custom("Roboto-Regular", size: 36))
                .foregroundColor(.red) +
             Text(" a \n snow flake")
                .font(.custom("Roboto-Regular", size: 36))
                .foregroundColor(.primary))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var hostMessage: some View {
        if !webSocketManager.messageFromHost.isEmpty {
            Text("\(webSocketManager.messageFromHost)")
                .font(.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .title2).pointSize))
                .foregroundColor(.black)
        } else {
            Text("It's Business Time!")
                .font(.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .title2).pointSize))
                .foregroundColor(.black)
        }
    }
}
