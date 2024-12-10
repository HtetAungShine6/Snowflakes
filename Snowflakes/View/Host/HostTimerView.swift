//
//  HostTimerView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct HostTimerView: View {
    
//    @EnvironmentObject var navigationManager: NavigationManager
    
    let navBarTitle: String
    let navBarSubtitle: String
    let image: Image
    
    @State private var currentTitle: String
    @State private var currentSubtitle: String
    @State private var currentImage: Image
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var inputText: String = ""

    init(navBarTitle: String, navBarSubtitle: String, image: Image) {
        self.navBarTitle = navBarTitle
        self.navBarSubtitle = navBarSubtitle
        self.image = image
        _currentTitle = State(initialValue: navBarTitle)
        _currentSubtitle = State(initialValue: navBarSubtitle)
        _currentImage = State(initialValue: image)
    }

    var body: some View {
        
        TimerBackground(
            image: currentImage,
            navBarTitle: currentTitle,
            navBarSubtitle: currentSubtitle,
            navBarButtonImageName: "shop2",
            navBarButtonAction: {
                print("NavBar button tapped")
            }
        ) {
            
            VStack(spacing: 15) {
                PauseButton {
                    // Action here
                }
                HStack {
                    Text("Adjust Time")
                        .font(.custom("Roboto-Regular", size: 24))
                    Spacer()
                }
                .padding(.horizontal)
                AdjustTimeComponent(
                    onDecrease: { updatedMinutes, updatedSeconds in
                        minutes = updatedMinutes
                        seconds = updatedSeconds
                    },
                    onIncrease: { updatedMinutes, updatedSeconds in
                        minutes = updatedMinutes
                        seconds = updatedSeconds
                    }
                )
                HStack {
                    Text("Send a message")
                        .font(.custom("Roboto-Regular", size: 24))
                    Spacer()
                }
                .padding(.horizontal)
                CustomTextFieldWithButton(
                    placeholder: "Create a Snowflake",
                    text: $inputText) {
                        print("Message sent")
                    }
                    .padding(.horizontal)
                
                Spacer()
                
                SwipeToConfirmButton {
                    print("OK")
                }
            }
        }
        .onAppear(perform: loadData)
//        .navigationBarBackButtonHidden()
    }

    private func loadData() {
        DispatchQueue.main.async() {
            currentTitle = "Snowflake"
            currentSubtitle = "Round (1/5)"
            currentImage = Image("Snowman")
        }
    }
}

#Preview {
    HostTimerView(navBarTitle: "Loading...", navBarSubtitle: "Please wait", image: Image(systemName: "hourglass"))
}

