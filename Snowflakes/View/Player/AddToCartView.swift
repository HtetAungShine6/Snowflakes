//
//  AddToCartView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 13/2/25.
//

import SwiftUI

struct AddToCartView: View {
    
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getAddToCartItems = GetAddToCartViewModel()
    @StateObject private var exchangeStocksVM = ExchangeStocksViewModel()
    @StateObject private var removeCartVM = RemoveAddToCartViewModel()
    @State private var cartItems: [AddToCartResponseMessage] = []
    @State private var showDeleteAlert: Bool = false
    @State private var selectedItemId: String = ""
    @State private var selectedItem: String = ""
    @State private var showRemoveAlert: Bool = false
    @State private var showExchangeAlert: Bool = false
    @State private var showExchangeAlertError: Bool = false
    
    let playerRoomCode: String
    let teamNumber: Int
    var roundNumber: Int
    let hostRoomCode: String

    var body: some View {
       
        VStack {
            Text("Your Cart")
                .font(.title)
                .bold()
                .padding()
            
            List {
                ForEach(cartItems, id: \.id) { item in
                    HStack {
                        Text("\(item.productName)")
                        Spacer()
                        Text("$\(item.price) x \(item.quantity)")
                            .foregroundColor(.gray)
                        Image(systemName: "trash")
                            .onTapGesture {
                                selectedItemId = item.id
                                selectedItem = item.productName
                                showDeleteAlert = true
                            }
                    }
                }
            }
            .refreshable {
                getAddToCartItems.fetchItems(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
            }
            .padding()

            HStack {
                Text("Total: ")
                    .font(.headline)
                Spacer()
                Text("$\(totalPrice)")
                    .font(.headline)
                    .bold()
            }
            .padding()

            Button(action: {
                exchangeStocksVM.cartIds = cartItems.map { item in item.id }
                exchangeStocksVM.hostRoomCode = hostRoomCode
                exchangeStocksVM.playerRoomCode = playerRoomCode
                exchangeStocksVM.roundNumber = roundNumber
                exchangeStocksVM.teamNumber = teamNumber
                exchangeStocksVM.products = cartItems.map { item in
                    ProductDTO(productName: item.productName, quantity: item.quantity)
                }
                exchangeStocksVM.exchangeStocks()
            }) {
                Text("Checkout")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.frostBlue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
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
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            getAddToCartItems.fetchItems(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
        }
        .onReceive(getAddToCartItems.$addToCartItems) { addToCartItems in
            self.cartItems = addToCartItems
            print("Add To Cart: \(addToCartItems)")
        }
        .onReceive(removeCartVM.$isSuccess) { success in
            showRemoveAlert = success
        }
        .onReceive(exchangeStocksVM.$isSuccess) { success in
            showExchangeAlert = success
        }
        .onReceive(exchangeStocksVM.$errorMessage) { errorMessage in
            if errorMessage != nil {
                showExchangeAlertError = true
            }
         }
        .alert("Do you want to remove \(selectedItem)", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                removeCartVM.removeCart(id: selectedItemId)
                showDeleteAlert = false
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("\(removeCartVM.message)", isPresented: $showRemoveAlert) {
            Button("OK", action: {
                showRemoveAlert = false
            })
            Button("Cancel", role: .cancel) {}
        }
        .alert("Items Checkout successfully.", isPresented: $showExchangeAlert) {
            Button("OK", action: {
                showExchangeAlert = false
            })
            Button("Cancel", role: .cancel) {}
        }
        .alert("\(exchangeStocksVM.errorMessage ?? "Cannot Buy Items")", isPresented: $showExchangeAlertError) {
            Button("OK", action: {
                showExchangeAlertError = false
            })
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var totalPrice: Int {
        cartItems.reduce(0) { $0 + ($1.price * Int($1.quantity)) }
    }
}
