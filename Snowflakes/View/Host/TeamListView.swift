//
//  TeamListView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/11/2024.
//

import SwiftUI

struct TeamListView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
//    let hostRoomCode: String?
//    let playerRoomCode: String?
//    let teamsMockUp: [TeamMockUp] = teamListMockUp
    let teams: [Team]
    
    var body: some View {

        VStack(alignment: .leading) {
            navBar
            totalNumberHostPlayer
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(teams, id: \.teamNumber) { team in
                        teamCardView(team: team)
                            .padding(.bottom, 8)
                    }
                }
                .padding()
            }
            startPlaygroundButton
                .padding()
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack(alignment: .leading) {
                if let hostRoomCode = teams.first?.hostRoomCode {
                    Text("Host Room Code: \(hostRoomCode)")
                        .font(.custom("Lato-Regular", size: 16))
                }
                if let playerRoomCode = teams.first?.playerRoomCode {
                    Text("Player Room Code: \(playerRoomCode)")
                        .font(.custom("Lato-Regular", size: 16))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members?.count ?? 0)
        }
    }
    
    private var totalNumberHostPlayer: some View{
        HStack {
            Text("Player: \(totalPlayerCount)") //call api
                .font(.custom("Lato-Medium", size: 15))
            Text("Host: 2") //call api
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
//                ForEach(["scissors", "paper", "pen"], id: \.self) { itemName in
//                    if let count = team.items[itemName] {
//                        VStack {
//                            Image(itemName)
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                            Text("\(count)x")
//                                .font(.custom("Lato-Regular", size: 16))
//                                .foregroundStyle(Color.gray)
//                        }
//                    }
//                }
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
                if team.members != nil {
                    Text("\(String(describing: team.members?.joined(separator: ", ")))")
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
    
    private var startPlaygroundButton: some View {
        Button(action: {
            navigationManager.navigateTo(Destination.gameView)
            navigationManager.isShopTime = false
        }) {
            Text("Start a playground")
                .font(.custom("Lato-Bold", size: 20))
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.frostBlue)
                .foregroundStyle(.black)
                .cornerRadius(10)
        }
    }
}

//#Preview {
//    TeamListView(hostRoomCode: "ABC12", playerRoomCode: "DFH123")
//}

