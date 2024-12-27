//
//  ShopItemRow.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/12/2024.
//

import SwiftUI

struct ShopItemRow: View {
    @ObservedObject var item: ShopItemViewModel
    
    var body: some View {
        HStack {
            Image(item.productName)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(item.productName)
                .font(.custom("Lato-Bold", size: 20))
            Spacer()
            Button(action: {
                if item.remainingStock > 1 {
                    item.remainingStock -= 1
                }
            }) {
                Image(systemName: "minus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
            TextField("", text: Binding(
                    get: { "\(item.remainingStock)" },
                    set: { item.remainingStock = Int($0) ?? item.remainingStock }
                )
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .disabled(true)
            Button(action: {
                item.remainingStock += 1
            }) {
                Image(systemName: "plus")
                    .foregroundStyle(AppColors.glacialBlue)
            }
        }
    }
}
