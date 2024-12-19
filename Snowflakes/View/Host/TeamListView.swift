//
//  TeamListView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/11/2024.
//

import SwiftUI

struct TeamListView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    let hostRoomCode: String
    let playerRoomCode: String
    let teams: [TeamMockUp] = teamListMockUp
    
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
        .navigationBarBackButtonHidden()
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            VStack {
                Text("Room Code: \(hostRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
                Text("Room Code: \(playerRoomCode)")
                    .font(.custom("Lato-Regular", size: 16))
            }
        }
        .padding(.horizontal)
    }
    
    private var totalNumberHostPlayer: some View{
        HStack {
            Text("Player: 9/30") //call api
                .font(.custom("Lato-Medium", size: 15))
            Text("Host: 2") //call api
                .font(.custom("Lato-Medium", size: 15))
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: TeamMockUp) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Text("(\(team.playersCount) Players)")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundStyle(Color.gray)
            }
            
            HStack(spacing: 10) {
                ForEach(["scissors", "paper", "pen"], id: \.self) { itemName in
                    if let count = team.items[itemName] {
                        VStack {
                            Image(itemName)
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("\(count)x")
                                .font(.custom("Lato-Regular", size: 16))
                                .foregroundStyle(Color.gray)
                        }
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
                Text("\(team.members.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
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

#Preview {
    TeamListView(hostRoomCode: "ABC12", playerRoomCode: "DFH123")
}

