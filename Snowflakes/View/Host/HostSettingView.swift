//
//  HostSettingView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/11/2024.
//

import SwiftUI

struct HostSettingView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var createPlaygroundVM = CreatePlaygroundViewModel()
    @ObservedObject private var getTeamsByRoomCodeVM = GetTeamsByRoomCode()
    
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
    
    @State private var showAlertView: Bool = false
    
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
                            .font(.custom("Lato-Bold", size: 20))
                            .foregroundColor(.white)
                        Text("This may take a few seconds.")
                            .font(.custom("Lato-Regular", size: 16))
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
        .onChange(of: createPlaygroundVM.isLoading, { oldValue, newValue in
            if newValue {
                showAlertView = true
            } else {
                showAlertView = false
            }
        })
        .onReceive(getTeamsByRoomCodeVM.$teams) { teams in
            if !teams.isEmpty {
                navigationManager.navigateTo(Destination.teamListView(team: teams))
            }
        }
        .onReceive(getTeamsByRoomCodeVM.$errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage)")
            }
        }
    }
    
    //MARK: - Setting Bar
    private var navBar: some View {
        HStack {
            Text("Settings")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack {
                Text("Host Room Code: \(formattedHostRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
                Text("Player Room Code: \(formattedPlayerRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
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
                    .font(.custom("Lato-Bold", size: 20))
                    .foregroundStyle(AppColors.polarBlue)
            }
            
            HStack {
                Text("Playground Round")
                    .font(.custom("Lato-Bold", size: 20))
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
                    .font(.custom("Lato-Bold", size: 20))
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
                .font(.custom("Lato-Bold", size: 20))
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
                    .font(.custom("Lato-Bold", size: 20))
                    .foregroundStyle(AppColors.polarBlue)
            }
            HStack {
                Text("Team Number")
                    .font(.custom("Lato-Bold", size: 20))
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
                Button(action: {
                    teamNumber += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
            HStack {
                Text("Team Token")
                    .font(.custom("Lato-Bold", size: 20))
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
                    .font(.custom("Lato-Bold", size: 20))
                    .foregroundStyle(AppColors.polarBlue)
            }
            
            // Dynamically create shop items
            ForEach(createShopItems(), id: \.productName) { item in
                ShopItemRow(item: item)
            }
        }
        .padding()
    }
    
    private func createShopItems() -> [ShopItemViewModel] {
        return [
            ShopItemViewModel(productName: "Scissors", price: 5, remainingStock: scissors),
            ShopItemViewModel(productName: "Paper", price: 2, remainingStock: paper),
            ShopItemViewModel(productName: "Pen", price: 7, remainingStock: pen)
        ]
    }
    
    private var buttons: some View {
        HStack() {
            Spacer()
            Button(action: {
                // dismiss
                navigationManager.pop()
            }) {
                Text("Back")
                    .font(.custom("Lato-Bold", size: 20))
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
                // confirm
                
                var roundsData: [String: String] = [:]
                for index in 0..<playgroundRound {
                    let roundKey = "\(index + 1)"
                    let roundDuration = formatDuration(roundDuration[index])
                    roundsData[roundKey] = roundDuration
                }
                
                createPlaygroundVM.hostRoomCode = hostRoomCode
                createPlaygroundVM.playerRoomCode = playerRoomCode
                createPlaygroundVM.numberOfTeam = teamNumber
                createPlaygroundVM.teamToken = teamToken
                createPlaygroundVM.rounds = roundsData
                createPlaygroundVM.shopToken = 0
                createPlaygroundVM.shop = createShopItems()
                
                createPlaygroundVM.createPlayground()
                getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: hostRoomCode)
            }) {
                Text("Confirm")
                    .font(.custom("Lato-Bold", size: 20))
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

struct ShopItemRow: View {
    @ObservedObject var item: ShopItemViewModel
    
    var body: some View {
        HStack {
            Image(item.productName.lowercased())
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(item.productName)
                .font(.custom("Lato-Bold", size: 20))
            Spacer()
            Button(action: {
                if item.remainingStock > 1 {
                    item.remainingStock -= 1
                }
            }) {
                Image(systemName: "minus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
            TextField("", value: $item.remainingStock, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            Button(action: {
                item.remainingStock += 1
            }) {
                Image(systemName: "plus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
        }
    }
}


//#Preview {
//    HostSettingView()
//}

//    private var shop: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Image("shop")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 30)
//                Text("Shop")
//                    .font(.custom("Lato-Bold", size: 20))
//                    .foregroundStyle(AppColors.polarBlue)
//            }
//            HStack {
//                Image("scissors")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 30)
//                Text("Scissors")
//                    .font(.custom("Lato-Bold", size: 20))
//                Spacer()
//                Button(action: {
//                    if scissors > 1 {
//                        scissors -= 1
//                    }
//                }) {
//                    Image(systemName: "minus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//                TextField("", value: $scissors, formatter: NumberFormatter())
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 50)
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                Button(action: {
//                    scissors += 1
//                }) {
//                    Image(systemName: "plus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//            }
//            HStack {
//                Image("paper")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 30)
//                Text("Paper")
//                    .font(.custom("Lato-Bold", size: 20))
//                Spacer()
//                Button(action: {
//                    if paper > 1 {
//                        paper -= 1
//                    }
//                }) {
//                    Image(systemName: "minus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//                TextField("", value: $paper, formatter: NumberFormatter())
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 50)
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                Button(action: {
//                    paper += 1
//                }) {
//                    Image(systemName: "plus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//            }
//            HStack {
//                Image("pen")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 30)
//                Text("Pen")
//                    .font(.custom("Lato-Bold", size: 20))
//                Spacer()
//                Button(action: {
//                    if pen > 1 {
//                        pen -= 1
//                    }
//                }) {
//                    Image(systemName: "minus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//                TextField("", value: $pen, formatter: NumberFormatter())
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 50)
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                Button(action: {
//                    pen += 1
//                }) {
//                    Image(systemName: "plus")
//                        .foregroundStyle(AppColors.glacialBlue)
//                }
//            }
//        }
//        .padding()
//    }
