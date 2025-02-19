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
    @State private var hasCheckedOut: Bool = false
    
    let playerRoomCode: String
    let teamNumber: Int
    var roundNumber: Int
    let hostRoomCode: String

    var body: some View {
       
        VStack {
            
            title
            cartList
            checkoutButton
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
            if success {
                hasCheckedOut = true
                showExchangeAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigationManager.pop()
                }
            }
        }
        .onReceive(exchangeStocksVM.$errorMessage) { errorMessage in
            if errorMessage != nil {
                showExchangeAlertError = true
            }
        }
        .alert("Do you want to remove \(selectedItem)", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                removeCartVM.removeCart(id: selectedItemId)
                // Remove the item from the list after successful deletion
                if let index = cartItems.firstIndex(where: { $0.id == selectedItemId }) {
                    cartItems.remove(at: index)
                }
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
    
    private var title: some View {
        // Title
        Text("Your Cart")
            .font(.title)
            .bold()
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(AppColors.frostBlue)
            .cornerRadius(10)
            .foregroundColor(.primary)
    }
    
    private var cartList: some View {
        // Cart List (Hide items after checkout)
        VStack {
            if !hasCheckedOut {
                List {
                    ForEach(cartItems, id: \.id) { item in
                        HStack {
                            Text("\(item.productName)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("$\(item.price) x \(item.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            // Trash Icon for item removal
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    selectedItemId = item.id
                                    selectedItem = item.productName
                                    showDeleteAlert = true
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)).shadow(radius: 5))
                        .padding(.vertical, 4)
                    }
                }
                .refreshable {
                    getAddToCartItems.fetchItems(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
                }
                .padding()
            } else {
                Color.clear
                    .frame(height: CGFloat(cartItems.count * 60))
            }
        }
    }
    
    private var totalPriceSection: some View {
        // Total Price Section
        VStack {
            HStack {
                Text("Total: ")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("$\(totalPrice)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
    
    private var totalPrice: Int {
        cartItems.reduce(0) { $0 + ($1.price * Int($1.quantity)) }
    }
    
    private var checkoutButton: some View {
        // Checkout Button
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
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.frostBlue)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddToCartView(playerRoomCode: "ASDAD", teamNumber: 1, roundNumber: 2, hostRoomCode: "AFASDASD")
}
