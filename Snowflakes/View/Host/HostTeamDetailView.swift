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
    @State private var itemTransactions: [ItemTransitionMessage] = []
    @State private var images: [ImageTransitionMessage] = []
    @State private var selectedImage: String?
    @State private var price: String = ""
    @State private var showImageBuyAlert: Bool = false
    @State private var showDecisionAlert: Bool = false
    @State private var showRejectAlert: Bool = false
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
            networkCalls()
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
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            networkCalls()
        }
        .onReceive(getTeamDetailVM.$team) { team in
            self.team = team
        }
        .onReceive(getTransactionVM.$transactions) { transactions in
            self.transactions = transactions
        }
        .onReceive(getTransactionVM.$itemTransactions) { items in
            self.itemTransactions = items
        }
        .onReceive(getTransactionVM.$imageTransactions) { images in
            self.images = images
        }
        .onReceive(buyImageVM.$message) { message in
            if !message.isEmpty {
                showAlert = true
            }
        }
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
                .padding(.horizontal, 10)
            Text("Tap image to transfer tokens")
                .font(.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                .foregroundStyle(Color.gray.opacity(0.75))
                .padding(.horizontal, 10)
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
                            .padding(.horizontal, 10)
                    }
                }
            }
            .padding(.horizontal, 5)
            .alert("Do you consider buying this Snowflake?", isPresented: $showDecisionAlert) {
                Button("Buy", action: {
                    showImageBuyAlert = true
                })
                Button("Reject", role: .destructive) {
                    showRejectAlert = true
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
            .alert("Do you like to reject buying this Snowflake?", isPresented: $showRejectAlert) {
                Button("Confirm", action: {
                    if let image = selectedImage {
                        buyImageVM.isBuyingConfirmed = false
                        buyImageVM.hostRoomCode = hostRoomCode
                        buyImageVM.playerRoomCode = team?.playerRoomCode ?? ""
                        buyImageVM.roundNumber = roundNumber
                        buyImageVM.teamNumber = teamNumber
                        buyImageVM.imageUrl = image
                        buyImageVM.price = 0
                        buyImageVM.buy()
                    }
                    showRejectAlert = false
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
            Text("Sold Images")
                .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
            if images.isEmpty {
                VStack {
                    Text("No images sold out yet.")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                        .foregroundStyle(Color.gray.opacity(0.75))
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(images, id: \.imageId) { transaction in
                            VStack {
                                Image(transaction.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            Text("Purchased Items")
                .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
            if images.isEmpty {
                VStack {
                    Text("No items sold out yet.")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
                        .foregroundStyle(Color.gray.opacity(0.75))
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(itemTransactions, id: \.itemId) { transaction in
                            VStack {
                                Image(transaction.itemName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading) {
                                    Text(transaction.itemName)
                                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                                        .lineLimit(1)
                                    
                                    Text("Quantity: \(transaction.quantity)")
                                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                                        .foregroundStyle(Color.gray)
                                        .lineLimit(1)
                                    
                                    Text("Total: \(transaction.total) tokens")
                                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                                        .foregroundStyle(Color.gray)
                                        .lineLimit(1)
                                }
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func networkCalls() {
        getTeamDetailVM.fetchTeams(hostRoomCode: hostRoomCode, teamNumber: teamNumber)
        getTransactionVM.fetchTransactions(hostRoomCode: hostRoomCode, roundNumber: roundNumber, teamNumber: teamNumber)
        getTransactionVM.fetchItemTransactions(hostRoomCode: hostRoomCode, roundNumber: roundNumber, teamNumber: teamNumber)
        getTransactionVM.fetchImageTransactions(hostRoomCode: hostRoomCode, roundNumber: roundNumber, teamNumber: teamNumber)
    }
}

#Preview{
    HostTeamDetailView(teamNumber: 1, hostRoomCode: "ABCDEF", roundNumber: 2)
}
