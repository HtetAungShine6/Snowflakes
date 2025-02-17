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
//                                removeCartVM.removeCart(id: item.id)
                                selectedItemId = item.id
                                selectedItem = item.productName
                                showDeleteAlert = true
                            }
                    }
                }
            }

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
        .alert("Do you want to remove \(selectedItem)", isPresented: $showDeleteAlert) {
            Button("Remove", action: {
                removeCartVM.removeCart(id: selectedItemId)
                showDeleteAlert = false
            })
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var totalPrice: Int {
        cartItems.reduce(0) { $0 + ($1.price * Int($1.quantity)) }
    }
}
