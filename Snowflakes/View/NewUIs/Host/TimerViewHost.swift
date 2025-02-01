//
//  TimerView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/12/2024.
//

import SwiftUI
 
struct TimerViewHost: View {
    
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
            sendMessageField
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
            getGameStateViewModel.fetchGameState(hostRoomCode: roomCode)
            getPlaygroundVM.fetchPlayground(hostRoomCode: roomCode)
            hasNavigated = false
            hasStartedCountdown = false
        }
        .onReceive(getPlaygroundVM.$playgroundInfo) { playgroundInfo in
            if let rounds = playgroundInfo?.rounds, !rounds.isEmpty {
                navigationManager.totalRound = rounds.count
            }
        }
        .onChange(of: getPlaygroundVM.isLoading, { _, newValue in
            if newValue {
                // show alert
            } else {
                // hide alert
            }
        })
        .onReceive(webSocketManager.$currentGameState) { currentGameState in
            if currentGameState == "ShopPeriod" && !hasNavigated {
                navigationManager.navigateTo(Destination.hostShopTimerView(roomCode: roomCode))
                hasNavigated = true
                hasStartedCountdown = true
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
                
                Text("Round (\(getGameStateViewModel.currentRoundNumber)/\(navigationManager.totalRound))")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Text("Host Room Code: \(roomCode)")
                .font(.custom("Lato-Regular", size: 16))
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
        Image("Snowman")
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
    
    private var sendMessageField: some View {
        VStack {
            HStack {
                Text("Send a message")
                    .font(.custom("Roboto-Regular", size: 24))
                    .foregroundStyle(Color.black)
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                TextField("Create a snowflake", text: $sendMessageText)
                    .padding(.leading, 10)
                    .frame(height: 80)
 
                Button(action: {
                    print("Send a message text field is tapped.")
                }) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                        .padding(.trailing, 10)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
            )
            .frame(height: 80)
            .padding(.horizontal)
        }
    }
    
    private var nextRoundButton: some View {
        SwipeToConfirmButton {
            webSocketManager.stopCountdown(roomCode: roomCode)
            webSocketManager.createTimer(roomCode: roomCode, socketMessage: "02:00", gameState: "ShopPeriod")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                webSocketManager.startCountdown(roomCode: roomCode)
                webSocketManager.pauseCountdown(roomCode: roomCode)
            }
            DispatchQueue.main.async {
                updateGameStateViewModel.hostRoomCode = roomCode
                updateGameStateViewModel.currentGameState = GameState.ShopPeriod
                updateGameStateViewModel.currentRoundNumber = getGameStateViewModel.currentRoundNumber
                updateGameStateViewModel.updateGameState()
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
//            isButtonDisabled = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                isButtonDisabled = false
//            }
//        } label: {
//            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 25, height: 25)
//        }
//        .disabled(isButtonDisabled)
//        .frame(width: 40, height: 40)
//        .foregroundColor(.white)
//        .padding()
//        .background(AppColors.glacialBlue)
//        .clipShape(Circle())
//        .shadow(color: AppColors.glacialBlue, radius: 5, x: 0, y: 1)
//    }
