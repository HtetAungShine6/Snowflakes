//
//  GalleryView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import SwiftUI
import Kingfisher

struct GalleryView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getLeaderboardVM = GetLeaderboardViewModel()
    @State private var leaderboard: [LeaderboardMessage] = []
    var teamNumber: Int
    var roomCode: String
    
    var body: some View {
        VStack {
 
            HStack {
                Text("Gallery")
                    .font(Font.custom("Lato", size: 22).weight(.medium))
                    .foregroundColor(.black)
                    .padding([.leading, .top], 10)
                
                Spacer()
            }

            ScrollView {
                VStack(spacing: 10) {
                    if let images = leaderboard.first?.soldImages {
                        ForEach(images, id: \.self) { imageUrl in
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 500, height: 500)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 10)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Team : \(teamNumber < 10 ? "0\(teamNumber)" : "\(teamNumber)")", displayMode: .inline)
        .onAppear {
            getLeaderboardVM.fetchLeaderboard(hostRoomCode: roomCode)
        }
        .onReceive(getLeaderboardVM.$leaderboard) { leaderboard in
            self.leaderboard = leaderboard
        }
    }
}
