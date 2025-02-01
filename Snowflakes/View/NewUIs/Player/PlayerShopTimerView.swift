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
                    
                    descriptionText
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
            hasNavigated = false
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
            if currentGameState == "SnowFlakeCreation" && !hasNavigated {
                if navigationManager.currentRound == navigationManager.totalRound {
                    navigationManager.navigateTo(Destination.leaderboard)
                } else {
                    navigationManager.currentRound += 1
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
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundStyle(Color.black)
                
                Text("Round (\(navigationManager.currentRound)/\(navigationManager.totalRound))")
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
}


//import SwiftUI
//
//struct PlayerTimerView: View {
//
//    @EnvironmentObject var navigationManager: NavigationManager
//    @EnvironmentObject var webSocketManager: WebSocketManager
//
//    @State private var timerValueFromSocket: String = ""
//
//
//    let navBarTitle: String
//    let navBarSubtitle: String
//    let image: Image
//
//    @State private var currentTitle: String
//    @State private var currentSubtitle: String
//    @State private var currentImage: Image
//
//    @State private var minutes: Int = 5
//    @State private var seconds: Int = 0
//    @State private var timerValueFromSocketHost: String = ""
//
//    init(navBarTitle: String, navBarSubtitle: String, image: Image) {
//        self.navBarTitle = navBarTitle
//        self.navBarSubtitle = navBarSubtitle
//        self.image = image
//        _currentTitle = State(initialValue: navBarTitle)
//        _currentSubtitle = State(initialValue: navBarSubtitle)
//        _currentImage = State(initialValue: image)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//
//                VStack(spacing: 20) {
//                    navBar
//                        .padding(.horizontal)
//                        .padding(.top, geometry.safeAreaInsets.top)
//
//                    VStack(spacing: 15) {
////                        timerCountdown
//                        timer
//                        timerImage
//                    }
//                    .frame(maxWidth: .infinity, alignment: .top)
//
//                    descriptionText
//                        .frame(maxWidth: .infinity, alignment: .top)
//                        .padding(.top, 150)
//                }
//                .padding(.top, -geometry.safeAreaInsets.top)
//
//            }
//        }
//        .background(
//            Image("timerBackground")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea(.all)
//        )
//        .onAppear(perform: loadData)
//        .navigationBarBackButtonHidden()
//    }
//
//    private var navBar: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(currentTitle)
//                    .font(.custom("Montserrat-Medium", size: 32))
//                    .foregroundColor(.black)
//                Text(currentSubtitle)
//                    .font(.custom("Roboto-Regular", size: 18))
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//            VStack(alignment: .trailing, spacing: 2) {
//                Text("Player Room Code: \(navigationManager.playerRoomCode ?? "N/A")")
//                    .font(.custom("Lato-Regular", size: 14))
//                    .foregroundColor(.black)
//                    .lineLimit(1)
//            }
//        }
//    }
//
//    private var timer: some View {
//        HStack {
//            Spacer()
//            Text("\(webSocketManager.countdown)")
//                .font(.custom("Montserrat-Medium", size: 40))
//                .foregroundColor(.black)
//            Spacer()
//        }
//    }
//
//    private var timerImage: some View {
//        currentImage
//            .resizable()
//            .scaledToFit()
//            .frame(width: 250, height: 226)
//            .padding(.top, 10)
//    }
//
//    private var descriptionText: some View {
//        Text("It is time to create snowflakes.")
//            .font(.custom("Lato", size: 36).weight(.medium))
//            .foregroundColor(.black)
//            .multilineTextAlignment(.center)
//            .padding(.horizontal)
//            .frame(maxWidth: .infinity, alignment: .top)
//    }
//
//    private func loadData() {
//        DispatchQueue.main.async {
//            currentTitle = "Snowflake"
//            currentSubtitle = "Round (1/5)"
//            currentImage = Image("Snowman")
//        }
//    }
//}
//
//#Preview {
//    PlayerTimerView(navBarTitle: "Loading...", navBarSubtitle: "Please wait", image: Image(systemName: "hourglass"))
//}
