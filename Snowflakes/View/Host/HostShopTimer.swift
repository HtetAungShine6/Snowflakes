//
//  HostShopTimer.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct HostShopTimer: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    @StateObject private var webSocketManager = WebSocketManager()
    
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
                navigationManager.navigateTo(Destination.hostShopView)
            }
        ) {
            
            VStack(spacing: 17) {
                PauseButton(isPlaying: webSocketManager.isConnected) {
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
                
                Text("It is time to sell a \n snow flake")
                    .font(.custom("Roboto-Regular", size: 32))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                
                SwipeToConfirmButton {
                    print("OK")
                    navigationManager.isShopTime.toggle()
                }
            }
        }
        .onAppear(perform: loadData)
    }

    private func loadData() {
        DispatchQueue.main.async() {
            currentTitle = "Snowflake"
            currentSubtitle = "Shop round"
            currentImage = Image("Shop 1")
        }
    }
}

#Preview {
    HostShopTimer(navBarTitle: "Loading...", navBarSubtitle: "Please wait", image: Image(systemName: "hourglass"))
}
