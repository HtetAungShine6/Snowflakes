//
//  LoadingViewTest.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/12/2024.
//

import SwiftUI

struct LoadingViewTest: View {
    var body: some View {
        ZStack {
            AppColors.frostBlue.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                Text("Creating your Playground...")
                    .font(.custom("Lato-Bold", size: 20))
                    .foregroundColor(.white)
                Text("This may take a few seconds.")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black).opacity(0.5))
        }
    }
}

#Preview {
    LoadingViewTest()
}

