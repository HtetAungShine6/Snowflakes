//
//  HostTeamDetailView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI
import Kingfisher

struct HostTeamDetailView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getTeamDetailVM = GetTeamDetailByRoomCode()
    @StateObject private var getTransactionVM = GetTransactionViewModel()
    @StateObject private var buyImageVM = BuyImageViewModel()
    @State private var team: Team? = nil
    @State private var transactions: [TransactionMessage] = []
    @State private var selectedImage: String?
    @State private var price: String = ""
    @State private var showImageBuyAlert: Bool = false
    @State private var showDecisionAlert: Bool = false
    @State private var showAlert: Bool = false
    
    var teamNumber: Int
    var hostRoomCode: String
    var roundNumber: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                teamLabel
                transferView
                notificationView
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
            getTransactionVM.fetchTransactions(hostRoomCode: hostRoomCode, roundNumber: roundNumber, teamNumber: teamNumber)
        }
        .onReceive(getTeamDetailVM.$team) { team in
            self.team = team
        }
        .onReceive(getTransactionVM.$transactions) { transactions in
            self.transactions = transactions
        }
        .onReceive(buyImageVM.$message) { message in
            if !message.isEmpty {
                showAlert = true
            }
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
                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                } else {
                    Text("No Team Found")
                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                }
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    if let tokens = team?.tokens {
                        Text("\(String(describing: tokens)) tokens")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                    } else {
                        Text("No tokens found")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
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
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
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
                .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                .padding(.horizontal)
            Text("Tap image to transfer tokens")
                .font(.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                .foregroundStyle(Color.gray.opacity(0.75))
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    if let images = team?.images {
                        ForEach(images, id: \.self) { imageUrl in
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    selectedImage = imageUrl
                                    showDecisionAlert = true
                                }
                        }
                    } else {
                        Text("No Images yet to be found.")
                            .font(.custom("Poppins-Regular", size: 15))
                            .foregroundStyle(Color.gray.opacity(0.75))
                            .padding(.horizontal)
                    }
                }
            }
            .alert("Do you consider buying this Snowflake?", isPresented: $showDecisionAlert) {
                Button("Buy", action: {
                    showImageBuyAlert = true
                })
                Button("Reject", role: .destructive) {
                    if let image = selectedImage, let price = Int(price) {
                        buyImageVM.isBuyingConfirmed = false
                        buyImageVM.hostRoomCode = hostRoomCode
                        buyImageVM.playerRoomCode = team?.playerRoomCode ?? ""
                        buyImageVM.roundNumber = roundNumber
                        buyImageVM.teamNumber = teamNumber
                        buyImageVM.imageUrl = image
                        buyImageVM.price = price
                        buyImageVM.buy()
                    }
                    showDecisionAlert = false
                }
            }
            .alert("Do you want to buy this Snowflake?", isPresented: $showImageBuyAlert) {
                VStack {
                    TextField("Name a price", text: $price)
                        .keyboardType(.numberPad)
                }
                Button("Buy", action: {
                    if let image = selectedImage, let price = Int(price) {
                        buyImageVM.isBuyingConfirmed = true
                        buyImageVM.hostRoomCode = hostRoomCode
                        buyImageVM.playerRoomCode = team?.playerRoomCode ?? ""
                        buyImageVM.roundNumber = roundNumber
                        buyImageVM.teamNumber = teamNumber
                        buyImageVM.imageUrl = image
                        buyImageVM.price = price
                        buyImageVM.buy()
                    }
                    showImageBuyAlert = false
                })
                
                Button("Cancel", role: .cancel) {}
            }
            .alert("\(buyImageVM.message)", isPresented: $showAlert) {
                Button("OK") {
                    showAlert = false
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    private var notificationView: some View {
        VStack(alignment: .leading) {
            Text("Notifications")
                .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
            if transactions.isEmpty {
                VStack {
                    Text("No transactions available")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                        .foregroundStyle(Color.gray.opacity(0.75))
                }
            } else {
                ForEach(transactions, id: \.productId) { transaction in
                    HStack {
                        Image(transaction.productName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        VStack(alignment: .leading) {
                            Text("\(transaction.productName)")
                                .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                            Text("Quantity: \(transaction.quantity) - Total: \(transaction.total) tokens")
                                .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview{
    HostTeamDetailView(teamNumber: 1, hostRoomCode: "ABCDEF", roundNumber: 2)
}
