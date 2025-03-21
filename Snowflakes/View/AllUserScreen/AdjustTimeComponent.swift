//
//  AdjustTimeComponent.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct AdjustTimeComponent: View {
    @State private var time: String = "01:00"
    
    var countdown: String
    var onDecrease: (String) -> Void = { _ in }
    var onIncrease: (String) -> Void = { _ in }
    
    var body: some View {
        HStack {
            let isMinusDisabled = countdownToSeconds(countdown) < 60
            
            // Decrease Button
            Button(action: {
                onDecrease(time)
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 25, height: 25)
            .contentShape(Circle())
            .foregroundColor(AppColors.glacialBlue)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
            .disabled(isMinusDisabled)
            
            // Display Time (MM:SS)
            Text(time)
                .font(.custom("Roboto-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize))
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
            .frame(width: 25, height: 25)
            .contentShape(Circle())
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
    
    private func countdownToSeconds(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        if components.count == 2 {
            return components[0] * 60 + components[1]
        }
        return 0 
    }
}
