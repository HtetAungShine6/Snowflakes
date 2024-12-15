//
//  PlayerShopItemView.swift
//  Snowflakes
//
//  Created by Hein Thant on 15/12/2567 BE.
//


import SwiftUI

struct PlayerShopItemView: View {
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

