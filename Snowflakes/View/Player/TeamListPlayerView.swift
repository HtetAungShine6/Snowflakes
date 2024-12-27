//
//  TeamListPlayerView.swift
//  Snowflakes
//
//  Created by Hein Thant on 23/11/2567 BE.
//

import SwiftUI

struct TeamListPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    let teams: [Team]
    
    var body: some View {

        VStack(alignment: .leading) {
            navBar
            totalNumberPlayers
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(teams, id: \.teamNumber) { team in
                        teamCardView(team: team)
                            .padding(.bottom, 8)
                    }
                }
                .padding()
            }
            waitingForHostButton
                .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            if let roomCode = teams.first?.playerRoomCode {
                Text("Room Code: \(roomCode)")
                    .font(.custom("Lato-Regular", size: 16))
            }
        }
        .padding(.horizontal)
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members?.count ?? 0)
        }
    }
    
    private var totalNumberPlayers: some View {
        HStack {
            Text("Player: \(totalPlayerCount)") // Call API or use local data
                .font(.custom("Lato-Medium", size: 15))
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Text("(\(team.members?.count ?? 0) Players)")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundStyle(Color.gray)
            }
            
            HStack(spacing: 10) {
                ForEach(team.teamStocks, id: \.self) { stock in
                    VStack {
                        Image(stock.productName)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(stock.remainingStock)x")
                            .font(.custom("Lato-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                    }
                }
                Spacer()
                HStack {
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: 16))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
                if let members = team.members {
                    Text("\(members.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                } else {
                    Text("No Member Here")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary))
    }
    
    private var waitingForHostButton: some View {
        HStack {
            Spacer()
            Text("Waiting for host to start..")
                .font(Font.custom("Lato-Regular", size: 20).weight(.medium))
                .foregroundColor(.black)
            Spacer()
        }
    }
}

#Preview {
    TeamListPlayerView(teams: [])
        .environmentObject(NavigationManager())
}
//#Preview {
//    TeamListView(hostRoomCode: "ABC12", playerRoomCode: "DFH123")
//}
//
