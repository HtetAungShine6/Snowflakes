//
//  PauseButton.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct PauseButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: "pause.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .frame(width: 40, height: 40)
        .foregroundColor(.white)
        .padding()
        .background(AppColors.glacialBlue)
        .clipShape(Circle())
        .shadow(color: AppColors.glacialBlue, radius: 5, x: 0, y: 1)
    }
}
