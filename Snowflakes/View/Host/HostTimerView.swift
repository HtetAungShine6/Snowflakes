//
//  HostTimerView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct HostTimerView: View {
    
    let navBarTitle: String
    let navBarSubtitle: String
    let image: Image

    @State private var currentTitle: String
    @State private var currentSubtitle: String
    @State private var currentImage: Image

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
            VStack {
                pauseButton
            }
        }
        .onAppear(perform: loadData)
    }
    
    private var pauseButton: some View {
        Button {
            
        }label: {
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
    
    private var adjustTimeComponent: some View {
        VStack(alignment: .leading) {
            Text("Adjust Time")
        }
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

