//
//  SwipeToConfrimButton.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct SwipeToConfirmButton: View {
    // Closure to handle the confirmation action
    let onConfirm: () -> Void

    // State variables
    @State private var offset: CGFloat = 0
    @State private var isConfirmed: Bool = false

    // Predefined dimensions
    private let totalWidth: CGFloat = 237
    private let height: CGFloat = 58
    private let handleWidth: CGFloat = 120

    var body: some View {
        ZStack(alignment: .leading) { // Align everything to the leading edge
            // Background of the swipe area
            RoundedRectangle(cornerRadius: height / 2)
                .fill(AppColors.frostBlue) // Background color
                .frame(width: totalWidth, height: height)

            // Draggable rounded rectangle
            RoundedRectangle(cornerRadius: height / 2)
                .fill(Color.white)
                .frame(width: handleWidth, height: height - 10) // Handle size
                .shadow(radius: 3)
                .overlay(
                    Text("Next Round")
                        .font(.custom("Roboto-Regular", size: 18))
                        .foregroundColor(.black)
                )
                .offset(x: offset) // Control the position of the draggable rectangle
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if !isConfirmed {
                                // Allow dragging only within bounds
                                offset = max(0, min(value.translation.width, totalWidth - handleWidth))
                            }
                        }
                        .onEnded { _ in
                            if offset > (totalWidth - handleWidth) / 2 {
                                isConfirmed = true
                                offset = totalWidth - handleWidth // Snap to the end
                                onConfirm()
                            } else {
                                offset = 0 // Reset to the start
                            }
                        }
                )
        }
        .frame(width: totalWidth, height: height) // Ensure the swipe area remains consistent
    }
}


#Preview {
    SwipeToConfirmButton{
        print("HEllo")
    }
}
