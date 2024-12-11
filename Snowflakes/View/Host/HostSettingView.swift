//
//  HostSettingView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/11/2024.
//

import SwiftUI

struct HostSettingView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    private let roomCode: String = {
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
    
    
    var body: some View {
        
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Action for the back button
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    //MARK: - Setting Bar
    private var navBar: some View {
        HStack {
            Text("Settings")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            Text("Room Code: \(formattedRoomCode)")
                .font(.custom("Lato-Regular", size: 16))
        }
        .padding(.horizontal)
    }
    
    private var formattedRoomCode: String {
        return roomCode
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
            HStack {
                Image("scissors")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Scissors")
                    .font(.custom("Lato-Bold", size: 20))
                Spacer()
                Button(action: {
                    if scissors > 1 {
                        scissors -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $scissors, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Button(action: {
                    scissors += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
            HStack {
                Image("paper")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Paper")
                    .font(.custom("Lato-Bold", size: 20))
                Spacer()
                Button(action: {
                    if paper > 1 {
                        paper -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $paper, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Button(action: {
                    paper += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
            HStack {
                Image("pen")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("Pen")
                    .font(.custom("Lato-Bold", size: 20))
                Spacer()
                Button(action: {
                    if pen > 1 {
                        pen -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
                TextField("", value: $pen, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Button(action: {
                    pen += 1
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.glacialBlue)
                }
            }
        }
        .padding()
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
                    .frame(width: 144, height: 54)
                    .background(Color.clear)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            Button(action: {
                // confirm
                navigationManager.navigateTo(Destination.teamListView(roomCode: roomCode))
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

#Preview {
    HostSettingView()
}
