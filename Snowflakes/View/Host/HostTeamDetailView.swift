//
//  HostTeamDetailView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI

struct HostTeamDetailView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getTeamDetailVM = GetTeamDetailByRoomCode()
    @State private var team: Team? = nil
    
    var teamNumber: Int
    var hostRoomCode: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                teamLabel
                transferView
                Spacer()
            }
        }
        .refreshable {
            getTeamDetailVM.fetchTeams(hostRoomCode: hostRoomCode, teamNumber: teamNumber)
        }
        .safeAreaInset(edge: .top) {
            customToolbar
                .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            getTeamDetailVM.fetchTeams(hostRoomCode: hostRoomCode, teamNumber: teamNumber)
        }
        .onReceive(getTeamDetailVM.$team) { team in
            self.team = team
        }
    }
    
    private var customToolbar: some View {
        HStack {
            Button(action: {
                navigationManager.pop()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .frame(height: 50)
    }
    
    private var teamLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                if let teamNumber = team?.teamNumber {
                    Text("Team: \(teamNumber)")
                        .font(.custom("Lato-Bold", size: 20))
                } else {
                    Text("No Team Found")
                        .font(.custom("Lato-Bold", size: 20))
                }
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: 15))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    if let tokens = team?.tokens {
                        Text("\(String(describing: tokens)) tokens")
                            .font(.custom("Lato-Regular", size: 15))
                    } else {
                        Text("No tokens found")
                            .font(.custom("Lato-Regular", size: 15))
                    }
                }
            }
            Spacer()
            if let teamStocks = team?.teamStocks {
                ForEach(teamStocks, id: \.self) { item in
                    VStack {
                        Image(item.productName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(item.remainingStock)x")
                            .font(.custom("Lato-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    private var transferView: some View {
        VStack(alignment: .leading) {
            Text("Transfer")
                .font(.custom("Lato-Regular", size: 22))
            Text("Tap image to transfer tokens")
                .font(.custom("Poppins-Regular", size: 15))
                .foregroundStyle(Color.gray.opacity(0.75))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(0..<4, id: \.self) { _ in
                        Image("MockSnowflake")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 250)
                    }
                }
            }
//            TabView {
//                ForEach(0..<4, id: \.self) { _ in
//                    Image("MockSnowflake")
//                        .resizable()
//                        .scaledToFill()
//                        .clipped()
//                }
//            }
//            .tabViewStyle(PageTabViewStyle())
//            .indexViewStyle(.page(backgroundDisplayMode: .always))
//            .frame(height: 350)
        }
        .padding(.horizontal)
    }
}
