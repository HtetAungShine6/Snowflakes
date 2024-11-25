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
        VStack(alignment: .center) {
            // Navigation bar
            CustomNavBar(
                title: navBarTitle,
                subtitle: navBarSubtitle,
                buttonImageName: navBarButtonImageName,
                buttonAction: navBarButtonAction
            )
            
            // Timer display
            HStack(spacing: 40) {
                TimerUnitView(value: minutes, label: "Min")
                TimerUnitView(value: seconds, label: "Sec")
            }
            
            Spacer()
                .frame(height: 70)
            
            // Main Image
            image
                .resizable()
                .scaledToFit()
                .frame(width: 235, height: 235)
                .offset(y: -40)
            
            Spacer()
            
            // Additional content passed dynamically
            content()
        }
        .padding(.horizontal)
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
    }
}


//struct TimerBackground: View {
//    var image: Image
//    var navBarTitle: String
//    var navBarSubtitle: String
//    var navBarButtonImageName: String
//    var navBarButtonAction: () -> Void = {}
//
//    @State private var minutes: Int = 0
//    @State private var seconds: Int = 0
//
//    var body: some View {
//
//        // Main content
//        VStack(alignment: .center) {
//            CustomNavBar(
//                title: navBarTitle,
//                subtitle: navBarSubtitle,
//                buttonImageName: navBarButtonImageName,
//                buttonAction: navBarButtonAction
//            )
//
//            // Timer display
//            HStack(spacing: 40) {
//                TimerUnitView(value: minutes, label: "Min")
//                TimerUnitView(value: seconds, label: "Sec")
//            }
//
//            Spacer()
//                .frame(height: 70)
//
//            // Image
//            image
//                .resizable()
//                .scaledToFit()
//                .frame(width: 235, height: 235)
//                .offset(y: -40)
//
////            Spacer()
//
//        }
//        .padding(.horizontal)
//        .background(
//            Image("timerBackground")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea(.all)
//        )
//    }
//}


#Preview {
    TimerBackground(
        image: Image("Snowman"),
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

