//
//  HostSettingView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/11/2024.
//

import SwiftUI

struct HostSettingView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject private var webSocketManager: WebSocketManager
    
    @StateObject private var createPlaygroundVM = CreatePlaygroundViewModel()
    @StateObject private var createGameStateVM = CreateGameStateViewModel()
    
    @StateObject private var scissorsVM = ShopItemViewModel(productName: "Scissor", price: 5, remainingStock: 1)
    @StateObject private var paperVM = ShopItemViewModel(productName: "Paper", price: 2, remainingStock: 1)
    @StateObject private var penVM = ShopItemViewModel(productName: "Pen", price: 7, remainingStock: 1)
    
    private let hostRoomCode: String = {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let alphanumeric = letters + digits
        return String((0..<6).map { _ in alphanumeric.randomElement()! })
    }()
    
    private let playerRoomCode: String = {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let alphanumeric = letters + digits
        return String((0..<6).map { _ in alphanumeric.randomElement()! })
    }()
    
    @State private var playgroundRound: Int = 1
    @State private var roundDuration: [Int] = [240]
    @State private var teamNumber: Int = 1
    @State private var teamToken: Int = 1
    @State private var scissors: Int = 1
    @State private var paper: Int = 1
    @State private var pen: Int = 1
    @State private var errorPlaygroundCreateMessage: String = ""
    
    @State private var showAlertView: Bool = false
    @State private var showErrorAlertView: Bool = false
    
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
                        Text("Creating your Playground...")
                            .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title2).pointSize))
                            .foregroundColor(.white)
                        Text("This may take a few seconds.")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(40)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black).opacity(0.5))
                }
            } else {
                VStack(alignment: .leading) {
                    navBar
                    ScrollView {
                        VStack(alignment: .leading) {
                            playground
                            duration
                            team
                            shop
                        }
                    }
                    buttons
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: createPlaygroundVM.isLoading, { _, newValue in
            if newValue {
                showAlertView = true
            } else {
                showAlertView = false
            }
        })
        .onChange(of: createPlaygroundVM.isSuccess, { _, newValue in
            if newValue {
                createGameStateVM.hostRoomCode = hostRoomCode
                createGameStateVM.playerRoomCode = playerRoomCode
                createGameStateVM.currentGameState = .TeamCreation
                createGameStateVM.currentRoundNumber = 1
                createGameStateVM.createGameState()
            } else {
                errorPlaygroundCreateMessage = createPlaygroundVM.errorMessage ?? ""
                showErrorAlertView = true
            }
        })
        .onChange(of: createGameStateVM.isSuccess, { _, newValue in
            if newValue {
                webSocketManager.joinGroup(roomCode: hostRoomCode)
                navigationManager.navigateTo(Destination.teamListView(hostRoomCode: hostRoomCode))
            } else {
                errorPlaygroundCreateMessage = createGameStateVM.errorMessage ?? ""
                showErrorAlertView = true
            }
        })
        .onReceive(createPlaygroundVM.$errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                errorPlaygroundCreateMessage = errorMessage
                showErrorAlertView = true
            }
        }
        .onReceive(createGameStateVM.$errorMessage){ errorMessage in
            if let errorMessage = errorMessage {
                errorPlaygroundCreateMessage = errorMessage
                showErrorAlertView = true
            }
        }
        .alert("Error", isPresented: $showErrorAlertView, presenting: errorPlaygroundCreateMessage) { message in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
    }
    
    //MARK: - Setting Bar
    private var navBar: some View {
        HStack {
            Text("Settings")
                .font(.custom("Montserrat-SemiBold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack(alignment: .leading) {
                Text("Host Room Code: \(formattedHostRoomCode)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                Text("Player Room Code: \(formattedPlayerRoomCode)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
            }
        }
        .padding(.horizontal)
    }
    
    private var formattedHostRoomCode: String {
        return hostRoomCode
    }
    
    private var formattedPlayerRoomCode: String {
        return playerRoomCode
    }
    
    //MARK: - Playground
    private var playground: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image("gamecontroller")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Playground")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundStyle(AppColors.polarBlue)
            }
            
            HStack {
                Text("Playground Round")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                Spacer()
                Button(action: {
                    if playgroundRound > 1 {
                        playgroundRound -= 1
                        roundDuration.removeLast()
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $playgroundRound, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .disabled(true)
                Button(action: {
                    playgroundRound += 1
                    roundDuration.append(240)
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
        }
        .padding()
    }
    
    //MARK: - Duration
    private var duration: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("durationclock")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Duration")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundStyle(AppColors.polarBlue)
            }
            ForEach(0..<playgroundRound, id: \.self) { roundNumber in
                round(roundNumber: roundNumber + 1, duration: $roundDuration[roundNumber])
            }
        }
        .padding()
    }
    
    private func round(roundNumber: Int, duration: Binding<Int>) -> some View {
        
        HStack {
            Text("Round \(roundNumber)")
                .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
            Spacer()
            Button(action: {
                if duration.wrappedValue > 60 {
                    duration.wrappedValue -= 60
                }
            }) {
                Image(systemName: "minus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
            TextField("mm:ss", text: Binding(
                get: {
                    formatDuration(duration.wrappedValue)
                },
                set: { newValue in
                    if let totalSeconds = parseDuration(from: newValue) {
                        duration.wrappedValue = totalSeconds
                    }
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 70)
            .multilineTextAlignment(.center)
            .keyboardType(.numbersAndPunctuation)
            .disabled(true)
            Button(action: {
                duration.wrappedValue += 60
            }) {
                Image(systemName: "plus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
        }
    }
    
    private func formatDuration(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func parseDuration(from string: String) -> Int? {
        let components = string.split(separator: ":").map { String($0) }
        guard components.count == 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]),
              seconds >= 0 && seconds < 60 else {
            return nil
        }
        return minutes * 60 + seconds
    }
    
    //MARK: - Team
    private var team: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("teampeople")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Team")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundStyle(AppColors.polarBlue)
            }
            HStack {
                Text("Team Number")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                Spacer()
                Button(action: {
                    if teamNumber > 1 {
                        teamNumber -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $teamNumber, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .disabled(true)
                Button(action: {
                    teamNumber += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
            HStack {
                Text("Team Token")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                Spacer()
                Button(action: {
                    if teamToken > 1 {
                        teamToken -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $teamToken, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .disabled(true)
                Button(action: {
                    teamToken += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
        }
        .padding()
    }
    
    //MARK: - Shop
    private var shop: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("shop")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Shop")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundStyle(AppColors.polarBlue)
            }
            
            VStack {
                ShopItemRow(item: scissorsVM)
                ShopItemRow(item: paperVM)
                ShopItemRow(item: penVM)
            }
        }
        .padding()
    }
    
    private var buttons: some View {
        HStack() {
            Spacer()
            Button(action: {
                navigationManager.pop()
            }) {
                Text("Back")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .foregroundStyle(Color.secondary)
                    .frame(width: 144, height: 54)
                    .background(Color.clear)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Button(action: {
                
                var roundsData: [String: String] = [:]
                for index in 0..<playgroundRound {
                    let roundKey = "\(index + 1)"
                    let roundDuration = formatDuration(roundDuration[index])
                    roundsData[roundKey] = roundDuration
                }
                
                let shopData: [ShopItemViewModel] = [
                    ShopItemViewModel(productName: "Scissor", price: 10, remainingStock: scissorsVM.remainingStock),
                    ShopItemViewModel(productName: "Paper", price: 5, remainingStock: paperVM.remainingStock),
                    ShopItemViewModel(productName: "Pen", price: 15, remainingStock: penVM.remainingStock)
                ]
                
                DispatchQueue.main.async {
                    createPlaygroundVM.hostRoomCode = hostRoomCode
                    createPlaygroundVM.playerRoomCode = playerRoomCode
                    createPlaygroundVM.numberOfTeam = teamNumber
                    createPlaygroundVM.teamToken = teamToken
                    createPlaygroundVM.rounds = roundsData
                    createPlaygroundVM.shopToken = 0
                    createPlaygroundVM.shop = shopData
                    createPlaygroundVM.createPlayground()
                }
            }) {
                Text("Confirm")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .frame(width: 144, height: 54)
                    .background(AppColors.frostBlue)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview{
    HostSettingView()
}
