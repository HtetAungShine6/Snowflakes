//
//  TimerView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/12/2024.
//

import SwiftUI

struct TimerViewHost: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var webSocketManager = WebSocketManager()
    
    @State private var timerValueFromSocket: String = ""
    @State private var sendMessageText: String = ""
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
            webSocketManager.connect()
        }
        .onChange(of: webSocketManager.isConnected) { _, isConnected in
            if isConnected {
                webSocketManager.socketMessage = "01:00"
                webSocketManager.start()
            }
        }
        .onChange(of: webSocketManager.countdown) { _, newValue in
            timerValueFromSocket = newValue
        }
    }
    
    private var navBar: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Snowflake")
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundStyle(Color.black)
                Text("Round (1/5)")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
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
        Image("Snowman")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 226)
    }
    
    private var controlButton: some View {
        Button{
            isPlaying.toggle()
            if isPlaying {
                webSocketManager.resume()
            } else {
                webSocketManager.pause()
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
//                    webSocketManager.addedTimer = time
                },
                onIncrease: { time in
                    webSocketManager.addedTimer = time
                    webSocketManager.add()
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
            navigationManager.isShopTime.toggle()
        }
    }
}
