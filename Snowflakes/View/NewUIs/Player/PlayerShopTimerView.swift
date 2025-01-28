//
//  PlayerShopTimerView.swift
//  Snowflakes
//
//  Created by Hein Thant on 26/1/2568 BE.
//

import SwiftUI

struct PlayerShopTimerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var webSocketManager: WebSocketManager

    @State private var timerValueFromSocket: String = ""

    
    let navBarTitle: String
    let navBarSubtitle: String
    let image: Image
    
    @State private var currentTitle: String
    @State private var currentSubtitle: String
    @State private var currentImage: Image
    
    @State private var minutes: Int = 5
    @State private var seconds: Int = 0
    @State private var timerValueFromSocketHost: String = ""
    
    init(navBarTitle: String, navBarSubtitle: String, image: Image) {
        self.navBarTitle = navBarTitle
        self.navBarSubtitle = navBarSubtitle
        self.image = image
        _currentTitle = State(initialValue: navBarTitle)
        _currentSubtitle = State(initialValue: navBarSubtitle)
        _currentImage = State(initialValue: image)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                VStack(spacing: 20) {
                    navBar
                        .padding(.horizontal)
                        .padding(.top, geometry.safeAreaInsets.top)
                    
                    VStack(spacing: 15) {
//                        timerCountdown
                        timer
                        timerImage
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                    descriptionText
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.top, 150)
                }
                .padding(.top, -geometry.safeAreaInsets.top)
                
            }
        }
        .background(
            Image("timerBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
        .onAppear(perform: loadData)
        .navigationBarBackButtonHidden()
    }
    
    private var navBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(currentTitle)
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundColor(.black)
                Text(currentSubtitle)
                    .font(.custom("Roboto-Regular", size: 18))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                print("NavBar button tapped")
            }) {
                Image(systemName: "shop2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private var timer: some View {
        HStack {
            Spacer()
            Text("\(webSocketManager.countdown)")
                .font(.custom("Montserrat-Medium", size: 40))
                .foregroundColor(.black)
            Spacer()
        }
    }

    private var timerImage: some View {
        currentImage
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 226)
            .padding(.top, 10)
    }
    
    private var descriptionText: some View {
        Text("It is time to sell snowflakes.")
            .font(.custom("Lato", size: 36).weight(.medium))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            currentTitle = "Snowflake"
            currentSubtitle = "Shop round"
            currentImage = Image("Shop 1")
        }
    }
}

#Preview {
    PlayerShopTimerView(navBarTitle: "Loading...", navBarSubtitle: "Please wait", image: Image(systemName: "hourglass"))
}
