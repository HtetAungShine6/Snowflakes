//
//  LeaderboardView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

import SwiftUI

struct LeaderboardView: View {
    
    let teams: [LeaderboardMockUp] = leaderboardMockUp.sorted { lhs, rhs in
        // define with or without LeaderboardView (both works but how?)
        LeaderboardView.rankOrder(lhs.rank) < LeaderboardView.rankOrder(rhs.rank)
    }
    
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
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Leaderboard")
                    .font(.custom("Montserrat-SemiBold", size: 23))
                    .foregroundStyle(AppColors.polarBlue)
                Text("Tap Each team list to check gallery")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
            Spacer()
            Text("End Game Results")
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: LeaderboardMockUp) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Text("(\(team.playersCount) Players)")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text("\(team.rank)")
                    .font(.custom("Lato-Regular", size: 16))
            }
            
            HStack(spacing: 10) {
                ForEach(["Scissor", "Paper", "Pen"], id: \.self) { itemName in
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
                    .foregroundStyle(.black)
                Text("\(team.members.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
    }
    
    private static func rankOrder(_ rank: String) -> Int {
        switch rank {
        case "1st": return 1
        case "2nd": return 2
        case "3rd": return 3
        default: return Int.max
        }
    }
}

#Preview {
    LeaderboardView()
}
