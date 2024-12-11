//
//  TimerBackground.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct TimerBackground<Content: View>: View {
    var image: Image
    var navBarTitle: String
    var navBarSubtitle: String
    var navBarButtonImageName: String
    var navBarButtonAction: () -> Void
    let content: () -> Content

    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    var body: some View {
        VStack {
            // Navigation bar
            CustomNavBar(
                title: navBarTitle,
                subtitle: navBarSubtitle,
                buttonImageName: navBarButtonImageName,
                buttonAction: navBarButtonAction
            )
            
            // Timer display
//            VStack{
                HStack(spacing: 40) {
                    TimerUnitView(value: minutes, label: "Min")
                    TimerUnitView(value: seconds, label: "Sec")
                }
                
                // Main Image
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 226)
//            }
            
            // Additional content passed dynamically
            content()
        }
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
    }
}

#Preview {
    TimerBackground(
        image: Image("snowman1"),
        navBarTitle: "Snowflake",
        navBarSubtitle: "Round (1/5)",
        navBarButtonImageName: "shop2",
        navBarButtonAction: {
            print("Navigation button tapped")
        }
    ) {
        // Add content for the preview
        VStack {
            Text("This is a preview")
                .font(.headline)
                .padding()
            Text("Additional content can go here.")
                .font(.subheadline)
        }
        .padding()
    }
}

