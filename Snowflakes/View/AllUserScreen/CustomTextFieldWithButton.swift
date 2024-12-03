//
//  CreateSnowFlakeTextField.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct CustomTextFieldWithButton: View {
    // Placeholder for the TextField
    let placeholder: String
    // Binding for the TextField's text
    @Binding var text: String
    // Closure for the button action
    let onButtonTapped: () -> Void

    var body: some View {
        HStack {
            // TextField with placeholder
            TextField(placeholder, text: $text)
                .padding(.leading, 10) // Padding inside the TextField
                .frame(height: 60) // Adjust the height of the TextField

            // Button on the right
            Button(action: {
                onButtonTapped() // Trigger the provided action
            }) {
                Image(systemName: "chevron.right") // Chevron icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.black) // Icon color
                    .padding(.trailing, 10) // Padding for the button
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8) // Rounded border
                .stroke(Color.black, lineWidth: 1) // Black border
        )
        .frame(height: 60) // Total height of the TextField + Button
    }
}
