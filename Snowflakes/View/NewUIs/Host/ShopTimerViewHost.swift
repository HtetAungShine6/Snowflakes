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
    
    @State private var timerValueFromSocket: String = ""
    @State private var isPlaying: Bool = false
    
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
            shopLabel
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
            webSocketManager.createTimer(roomCode: webSocketManager.roomCode, socketMessage: "2:00")
        }
        .onChange(of: webSocketManager.timerCreated) { _, newValue in
            if newValue {
                webSocketManager.startCountdown(roomCode: webSocketManager.roomCode)
            }
        }
        .onChange(of: webSocketManager.timerStarted) { _, newValue in
            if newValue {
                webSocketManager.pauseCountdown(roomCode: webSocketManager.roomCode)
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
            Text("\(timerValueFromSocket)")
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
        Button{
            isPlaying.toggle()
            if isPlaying {
                webSocketManager.resumeCountdown(roomCode: webSocketManager.roomCode)
            } else {
                webSocketManager.pauseCountdown(roomCode: webSocketManager.roomCode)
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
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
                    webSocketManager.minusCountdown(roomCode: webSocketManager.roomCode, socketMessage: "01:00")
                },
                onIncrease: { time in
                    webSocketManager.addCountdown(roomCode: webSocketManager.roomCode, socketMessage: "01:00")
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
            webSocketManager.stopCountdown(roomCode: webSocketManager.roomCode)
            navigationManager.isShopTime.toggle()
        }
    }
}
