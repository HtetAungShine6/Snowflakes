//
//  HostShopView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI

struct HostShopView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    let teams: [TeamMockUp] = teamListMockUp
    
    var body: some View {
        VStack(alignment: .leading) {
            items
            teamList
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Shop")
                    .font(.custom("Montserrat-SemiBold", size: 24))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
//        .navigationDestination(for: TeamMockUp.self) { team in
//            HostTeamDetailView(team: team)
//        }
    }
    
    private var items: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Items")
                    .font(.custom("Lato-Bold", size: 24))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(shopItems, id: \.title) { item in
                        HostShopItemView(imageName: item.imageName, title: item.title)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var teamList: some View {
        VStack(alignment: .leading) {
            Text("Team List")
                .font(.custom("Lato-Bold", size: 24))
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(teams, id: \.teamNumber) { team in
                        teamCardView(team: team)
                            .padding(.bottom, 8)
                            .onTapGesture {
//                                navigationManager.path.append("TeamDetail")
//                                navigationManager.navigateTo(team)
//                                navigationManager.navigateTo(Destination.hostTeamDetailView(team: team))
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: TeamMockUp) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Spacer()
                Text("Players: \(team.playersCount) players")
                    .font(.custom("Lato-Regular", size: 20))
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
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
    }
}

#Preview {
    HostShopView()
}

struct HostShopItemView: View {
    var imageName: String
    var title: String
    var width: CGFloat = 130
    var height: CGFloat = 165

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding()

            Text(title)
                .font(.custom("Lato-Regular", size: 12))
        }
        .frame(maxWidth: width, maxHeight: height)
        .padding()
        .background(AppColors.frostBlue)
        .cornerRadius(20)
    }
}
