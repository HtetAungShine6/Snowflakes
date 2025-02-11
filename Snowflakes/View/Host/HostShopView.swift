//
//  HostShopView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI

struct HostShopView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getTeamsByRoomCodeVM = GetTeamsByRoomCode()
    @StateObject private var getShopVM = GetShopByRoomCodeViewModel()
    @State private var teams: [Team] = []
    @State private var shopItems: ShopMessageResponse? = nil
    
    let hostRoomCode: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                items
                teamList
            }
        }
        .refreshable {
            refreshData()
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
            ToolbarItem(placement: .principal) {
                Text("Shop")
                    .font(.custom("Montserrat-SemiBold", size: 24))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: hostRoomCode)
            getShopVM.fetchShop(hostRoomCode: hostRoomCode)
        }
        .onReceive(getTeamsByRoomCodeVM.$teams) { teams in
            self.teams = teams
        }
        .onReceive(getShopVM.$shopMessageResponse) { items in
            self.shopItems = items
        }
    }
    
    private var items: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Items")
                    .font(.custom("Lato-Bold", size: 24))
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let shopItems = shopItems {
                        ForEach(shopItems.shopStocks, id: \.productName) { item in
                            HostShopItemView(imageName: item.productName, title: item.productName, itemCount: item.remainingStock)
                        }
                    }
                }
            }
            .padding(.horizontal, 3)
        }
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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationManager.navigateTo(Destination.hostTeamDetailView(hostRoomCode: hostRoomCode, teamNumber: team.teamNumber))
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func teamCardView(team: Team) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Regular", size: 20))
                Spacer()
                if let member = team.members {
                    Text("Players: \(String(describing: member.count)) players")
                        .font(.custom("Lato-Regular", size: 20))
                } else {
                    Text("No player found")
                        .font(.custom("Lato-Regular", size: 20))
                }
            }
            
            HStack(spacing: 10) {
                ForEach(team.teamStocks, id: \.self) { itemName in
                    VStack {
                        Image("\(itemName.productName)")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("\(itemName.remainingStock)")
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
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
    }
    
    private var totalPlayerCount: Int {
        teams.reduce(0) { total, team in
            total + (team.members?.count ?? 0)
        }
    }
    
    private func refreshData() {
        getTeamsByRoomCodeVM.fetchTeams(hostRoomCode: hostRoomCode)
        getShopVM.fetchShop(hostRoomCode: hostRoomCode)
    }
}


struct HostShopItemView: View {
    var imageName: String
    var title: String
    var itemCount: Int
    var width: CGFloat = 130
    var height: CGFloat = 165

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding()

            HStack {
                Text("\(itemCount) x \(title) left")
                    .font(.custom("Lato-Regular", size: 12))
            }
        }
        .frame(maxWidth: width, maxHeight: height)
        .padding()
        .background(AppColors.frostBlue)
        .cornerRadius(20)
    }
}

#Preview{
    HostShopView(hostRoomCode: "ABCD")
}
