//
//  TeamListPlayerView.swift
//  Snowflakes
//
//  Created by Hein Thant on 23/11/2567 BE.
//

import SwiftUI

struct TeamListPlayerView: View {
    
    let roomCode: String
    let teams: [TeamMockUp] = teamListMockUp
    
    var body: some View {
        VStack(alignment: .leading) {   
            navBar
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(teams, id: \.teamNumber) { team in
                        teamCardView(team: team)
                            .padding(.bottom, 8)
                    }
                }
                .padding()
            }
            Spacer()
            HStack {
                Spacer()
                Text("Waiting for host to start..")
                    .font(Font.custom("Lato-Regular", size: 20).weight(.medium))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
        }
    }
    
    private var navBar: some View {
        HStack {
            Text("Team List")
                .font(.custom("Montserrat-SemiBold", size: 23))
                .foregroundStyle(AppColors.polarBlue)
            Spacer()
            Text("Room Code: \(roomCode)")
                .font(.custom("Lato-Regular", size: 16))
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
                Spacer()
    
                Button(action: {
                    print("Join button tapped for team \(team.teamNumber)")
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 53, height: 22)
                            .background(.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.50)
                                    .stroke(
                                        Color(red: 0, green: 0, blue: 0).opacity(0.50),
                                        lineWidth: 0.50
                                    )
                            )
                        Text("Join")
                            .font(Font.custom("Lato", size: 16).weight(.medium))
                            .foregroundColor(Color(red: 0, green: 1, blue: 0.38))
                    }
                }
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
                        .frame(height: 30)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: 16))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.black)
                Text("\(team.members.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
    }
}

#Preview {
    TeamListPlayerView(roomCode: "ABC12")
}
