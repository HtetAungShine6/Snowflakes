//
//  HostTeamDetailView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI

struct HostTeamDetailView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var team: TeamMockUp
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            teamLabel
            transferView
            Spacer()
        }
        .safeAreaInset(edge: .top) {
            customToolbar
                .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
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
            VStack(alignment: .leading){
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Bold", size: 20))
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: 15))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: 15))
                }
            }
            Spacer()
            ForEach(team.items.keys.sorted().reversed(), id: \.self) { itemName in
                VStack {
                    Image(itemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("\(team.items[itemName] ?? 0)x")
                        .font(.custom("Lato-Regular", size: 16))
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(.horizontal)
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

#Preview {
    HostTeamDetailView(
        team: TeamMockUp(
            teamNumber: 1,
            code: 1234,
            playersCount: 4,
            items: ["scissors": 2, "paper": 1, "pen": 3],
            tokens: 50,
            members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"]
        )
    )
}
