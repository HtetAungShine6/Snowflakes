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
    //    @StateObject private var timerModel = TimerModel()
    
    @State private var timerValueFromSocket: String = ""
    @State private var sendMessageText: String = ""
    @State private var isPlaying: Bool = false
    @State private var isButtonDisabled = false
    
    @State private var currentRound: Int = 0
    @State private var totalRounds: Int = 0
    
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
            adjustTimeField
            sendMessageField
            VStack {
                nextRoundButton
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
        .onAppear {
            getPlaygroundVM.fetchPlayground(hostRoomCode: roomCode)
            navigationManager.currentRound = currentRound + 1
        }
        .onReceive(getPlaygroundVM.$playgroundInfo) { playgroundInfo in
            if let rounds = playgroundInfo?.rounds, !rounds.isEmpty {
                totalRounds = rounds.count
            }
        }
        .onChange(of: webSocketManager.isConnected) { _, isConnected in
            if isConnected {
                // join
                webSocketManager.joinGroup(roomCode: roomCode)
            }
        }
        .onChange(of: getPlaygroundVM.isLoading, { _, newValue in
            if newValue {
                // show alert
            } else {
                // hide alert
            }
        })
        .onChange(of: getPlaygroundVM.isSuccess, { _, newValue in
            if newValue, let rounds = getPlaygroundVM.playgroundInfo?.rounds {
                let currentRoundDuration = rounds.first { $0.roundNumber == navigationManager.currentRound }?.duration ?? "0"
                webSocketManager.createTimer(roomCode: roomCode, socketMessage: currentRoundDuration)
                webSocketManager.startCountdown(roomCode: roomCode)
            }
        })
        .onChange(of: webSocketManager.timerStarted) { _, newValue in
            if newValue {
                webSocketManager.pauseCountdown(roomCode: roomCode)
                webSocketManager.timerStarted = false
            }
        }
    }
    
    private var navBar: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Snowflake")
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundStyle(Color.black)
                
                Text("Round (\(navigationManager.currentRound)/\(totalRounds))")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
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
        Button{
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
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .disabled(isButtonDisabled)
        .frame(width: 40, height: 40)
        .foregroundColor(.white)
        .padding()
        .background(AppColors.glacialBlue)
        .clipShape(Circle())
        .shadow(color: AppColors.glacialBlue, radius: 5, x: 0, y: 1)
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
            if currentRound < totalRounds {
                currentRound += 1
                // Optionally, notify the server or WebSocket about the round change
            } else {
                // Handle when all rounds are completed
                webSocketManager.stopCountdown(roomCode: roomCode)
                navigationManager.isShopTime.toggle()
            }
        }
    }
}
