//
//  LoadingScreen.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 04/01/2025.
//

import SwiftUI

struct LoadingScreen: View {
    
    let loadingText1: String
    let loadingText2: String 
    
    var body: some View {
        ZStack {
            AppColors.frostBlue.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                Text(loadingText1)
                    .font(.custom("Lato-Bold", size: 20))
                    .foregroundColor(.white)
                Text(loadingText2)
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black).opacity(0.5))
        }
    }
}
