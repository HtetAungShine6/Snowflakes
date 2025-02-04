//
//  ShopTimerViewHost.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 25/12/2024.
//

import SwiftUI
 
struct ShopTimerViewHost: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    @StateObject private var getPlaygroundVM = GetPlaygroundViewModel()
    @StateObject private var updateGameStateViewModel = UpdateGameStateViewModel()
    @StateObject private var getGameStateViewModel = GetGameStateViewModel()
    
    @State private var timerValueFromSocket: String = ""
    @State private var isPlaying: Bool = false
    @State private var isButtonDisabled = false
    @State private var hasNavigated: Bool = false
    
    @State private var gameState: String = ""
    
    let roomCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            navBar
            VStack(alignment: .center) {
                timer
                timerImage
                controlButton
            }
            .frame(maxWidth: .infinity, alignment: .top)
            Spacer()
            adjustTimeField
            Spacer()
            shopLabel
            Spacer()
            VStack {
                nextRoundButton
            }
            .frame(maxWidth: .infinity, alignment: .top)
            Spacer()
        }
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
        .navigationBarBackButtonHidden()
        .onAppear {
            getPlaygroundVM.fetchPlayground(hostRoomCode: roomCode)
            getGameStateViewModel.fetchGameState(hostRoomCode: roomCode)
            hasNavigated = false
        }
        .onReceive(webSocketManager.$currentGameState) { currentGameState in
            if currentGameState == "SnowFlakeCreation" && !hasNavigated {
                if getGameStateViewModel.currentRoundNumber == navigationManager.totalRound {
                    navigationManager.navigateTo(Destination.leaderboard)
                } else {
                    navigationManager.navigateTo(Destination.hostTimerView(roomCode: roomCode))
                    getGameStateViewModel.currentRoundNumber += 1
                    hasNavigated = true
                }
            }
        }
        .onChange(of: webSocketManager.timerPaused) { _, newValue in
            if newValue {
                isPlaying = false
            } else {
                isPlaying = true
            }
        }
    }
    
    private var navBar: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Snowflake")
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundStyle(Color.black)
                Text("Shop Round")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Button {
                print("Shop Button tapped!")
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
            Text("\(webSocketManager.countdown)")
                .font(.custom("Montserrat-Medium", size: 40))
                .foregroundColor(.black)
            Spacer()
        }
    }
    
    private var timerImage: some View {
        Image("Shop 1")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 226)
    }
    
    private var controlButton: some View {
        Button {
            isPlaying.toggle()
            if isPlaying {
                webSocketManager.resumeCountdown(roomCode: roomCode)
            } else {
                webSocketManager.pauseCountdown(roomCode: roomCode)
            }
            isButtonDisabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isButtonDisabled = false
            }
        } label: {
            ZStack {
                Circle()
                    .fill(AppColors.glacialBlue)
                    .frame(width: 70, height: 70)
                    .shadow(color: AppColors.glacialBlue, radius: 5, x: 0, y: 1)
                
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            }
        }
        .disabled(isButtonDisabled)
    }
    
    private var adjustTimeField: some View {
        VStack {
            HStack {
                Text("Adjust Time")
                    .font(.custom("Roboto-Regular", size: 24))
                    .foregroundStyle(Color.black)
                Spacer()
            }
            .padding(.horizontal)
            AdjustTimeComponent(
                onDecrease: { time in
                    webSocketManager.minusCountdown(roomCode: roomCode, socketMessage: "01:00")
                },
                onIncrease: { time in
                    webSocketManager.addCountdown(roomCode: roomCode, socketMessage: "01:00")
                }
            )
        }
    }
    
    private var shopLabel: some View {
        VStack {
            (Text("It is time to ")
                .font(.custom("Roboto-Regular", size: 32))
                .foregroundColor(.primary) +
             Text("sell")
                .font(.custom("Roboto-Regular", size: 32))
                .foregroundColor(.red) +
             Text(" a \n snow flake")
                .font(.custom("Roboto-Regular", size: 32))
                .foregroundColor(.primary))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var nextRoundButton: some View {
        SwipeToConfirmButton {
            if let rounds = getPlaygroundVM.playgroundInfo?.rounds.sorted(by: { $0.duration < $1.duration }),
               getGameStateViewModel.currentRoundNumber < rounds.count + 1 {
                
                let adjustedRoundIndex = min(getGameStateViewModel.currentRoundNumber, rounds.count - 1)
                
                if adjustedRoundIndex > 0 {
                    let currentRoundInfo = rounds[adjustedRoundIndex]
                    let duration = currentRoundInfo.duration
                    
                    webSocketManager.stopCountdown(roomCode: roomCode)
                    
                    if getGameStateViewModel.currentRoundNumber != navigationManager.totalRound {
                        webSocketManager.createTimer(roomCode: roomCode, socketMessage: duration, gameState: "SnowFlakeCreation")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            webSocketManager.startCountdown(roomCode: roomCode)
                            webSocketManager.pauseCountdown(roomCode: roomCode)
                        }
                    } else {
                        webSocketManager.createTimer(roomCode: roomCode, socketMessage: "01:00", gameState: "SnowFlakeCreation")
                    }
                    
                    DispatchQueue.main.async {
                        updateGameStateViewModel.hostRoomCode = roomCode
                        updateGameStateViewModel.currentGameState = GameState.SnowFlakeCreation
                        updateGameStateViewModel.currentRoundNumber = getGameStateViewModel.currentRoundNumber + 1
                        updateGameStateViewModel.updateGameState()
                    }
                } else {
                    DispatchQueue.main.async {
                        updateGameStateViewModel.hostRoomCode = roomCode
                        updateGameStateViewModel.currentGameState = GameState.Leaderboard
                        updateGameStateViewModel.updateGameState()
                    }
                }
            }
        }
    }
}


//    private var controlButton: some View {
//        Button{
//            isPlaying.toggle()
//            if isPlaying {
//                webSocketManager.resumeCountdown(roomCode: roomCode)
//            } else {
//                webSocketManager.pauseCountdown(roomCode: roomCode)
//            }
//        } label: {
//            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 25, height: 25)
//        }
//        .frame(width: 40, height: 40)
//        .foregroundColor(.white)
//        .padding()
//        .background(AppColors.glacialBlue)
//        .clipShape(Circle())
//        .shadow(color: AppColors.glacialBlue, radius: 5, x: 0, y: 1)
//    }
