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
                    .font(Font.custom("Lato", size: UIFont.preferredFont(forTextStyle: .body).pointSize).weight(.medium))
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Team : \(teamNumber < 10 ? "0\(teamNumber)" : "\(teamNumber)")")
                    .font(.custom("Montserrat-SemiBold", size: 24))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getLeaderboardVM.fetchLeaderboard(hostRoomCode: roomCode)
        }
        .onReceive(getLeaderboardVM.$leaderboard) { leaderboard in
            self.leaderboard = leaderboard
        }
    }
}
