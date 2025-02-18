//
//  LeaderboardView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

import SwiftUI

struct LeaderboardView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getLeaderboardVM = GetLeaderboardViewModel()
    @State private var leaderboard: [LeaderboardMessage] = []
    
    let roomCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            navBar
            ScrollView {
                VStack(alignment: .leading) {
                    if !leaderboard.isEmpty {
                        ForEach(leaderboard, id: \.teamNumber) { team in
                            teamCardView(team: team)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    navigationManager.navigateTo(Destination.galleryView(teamNumber: team.teamNumber, roomCode: roomCode))
                                }
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                getLeaderboardVM.fetchLeaderboard(hostRoomCode: roomCode)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            getLeaderboardVM.fetchLeaderboard(hostRoomCode: roomCode)
        }
        .onReceive(getLeaderboardVM.$leaderboard) { leaderboard in
            self.leaderboard = leaderboard
        }
    }
    
    private var navBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Leaderboard")
                    .font(.custom("Montserrat-SemiBold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                    .foregroundStyle(AppColors.polarBlue)
                Text("Tap Each team list to check gallery")
                    .font(.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
            Spacer()
            Text("End Game Results")
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: LeaderboardMessage) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                Text("(\(team.players.count) Players)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text("\(team.teamRank)")
                    .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
            }
            
            HStack(spacing: 10) {
                ForEach(team.stocks, id: \.productName) { item in
                    VStack {
                        Image(item.productName)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(item.remainingStock)x")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                            .foregroundStyle(Color.gray)
                    }
                }
                Spacer()
                HStack {
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                    Text("\(team.remainingTokens) tokens")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                }
            }
            
            HStack {
                Text("Members: ")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.black)
                Text("\(team.players.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary))
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

//#Preview {
//    LeaderboardView()
//}
