//
//  HostSettingView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/11/2024.
//

import SwiftUI

struct HostSettingView: View {
    
    private let roomCode: Int = Int.random(in: 00000...99999)
    
    @State private var playgroundRound: Int = 1
    @State private var roundDuration: [Int] = [240]
    @State private var teamNumber: Int = 1
    @State private var teamToken: Int = 1
    @State private var scissors: Int = 1
    @State private var paper: Int = 1
    @State private var pen: Int = 1
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                navBar
                playground
                duration
                team
                shop
                buttons
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Text("<")
                    .onTapGesture {
                        // go back to previous view
                    }
            }
        }
    }
    
    //MARK: - Setting Bar
    private var navBar: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 23))
            Spacer()
            Text("Room Code: \(formattedRoomCode)")
        }
        .padding(.horizontal)
    }
    
    private var formattedRoomCode: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.string(from: NSNumber(value: roomCode)) ?? "\(roomCode)"
    }
    
    //MARK: - Playground
    private var playground: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "gamecontroller")
                Text("Playground")
            }
            
            HStack {
                Text("Playground Round")
                Spacer()
                Button(action: {
                    if playgroundRound > 1 {
                        playgroundRound -= 1
                        roundDuration.removeLast()
                    }
                }) {
                    Image(systemName: "minus")
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
                }
            }
        }
        .padding()
    }
    
    //MARK: - Duration
    private var duration: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock")
                Text("Duration")
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
            Spacer()
            Button(action: {
                if duration.wrappedValue > 60 {
                    duration.wrappedValue -= 60
                }
            }) {
                Image(systemName: "minus")
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
                Image(systemName: "person.2")
                Text("Duration")
            }
            HStack {
                Text("Team Number")
                Spacer()
                Button(action: {
                    if teamNumber > 1 {
                        teamNumber -= 1
                    }
                }) {
                    Image(systemName: "minus")
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
                }
            }
            HStack {
                Text("Team Token")
                Spacer()
                Button(action: {
                    if teamToken > 1 {
                        teamToken -= 1
                    }
                }) {
                    Image(systemName: "minus")
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
                }
            }
        }
        .padding()
    }
    
    //MARK: - Shop
    private var shop: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "building")
                Text("Shop")
            }
            HStack {
                Image(systemName: "scissors")
                Text("Scissors")
                Spacer()
                Button(action: {
                    if scissors > 1 {
                        scissors -= 1
                    }
                }) {
                    Image(systemName: "minus")
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
                }
            }
            HStack {
                Image(systemName: "paperclip")
                Text("Paper")
                Spacer()
                Button(action: {
                    if paper > 1 {
                        paper -= 1
                    }
                }) {
                    Image(systemName: "minus")
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
                }
            }
            HStack {
                Image(systemName: "pencil")
                Text("Pen")
                Spacer()
                Button(action: {
                    if pen > 1 {
                        pen -= 1
                    }
                }) {
                    Image(systemName: "minus")
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
                print("Dismissed")
            }) {
                Text("Back")
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
                print("Confirmed")
            }) {
                Text("Confirm")
                    .frame(width: 144, height: 54)
                    .background(Color.blue)
                    .foregroundColor(.white)
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
