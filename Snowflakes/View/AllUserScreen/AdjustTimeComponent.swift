//
//  AdjustTimeComponent.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct AdjustTimeComponent: View {
    @State private var time: String = "01:00"
    
    var onDecrease: (String) -> Void = { _ in }
    var onIncrease: (String) -> Void = { _ in }

    var body: some View {
        HStack {
            // Decrease Button
            Button(action: {
                onDecrease(time)
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 30, height: 30)
            .foregroundColor(AppColors.glacialBlue)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
            
            // Display Time (MM:SS)
            Text(time)
                .font(.custom("Roboto-Regular", size: 32))
                .foregroundStyle(Color.black)
                .frame(minWidth: 80)
            
            // Increase Button
            Button(action: {
                onIncrease(time)
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 30, height: 30)
            .foregroundColor(AppColors.glacialBlue)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
}
