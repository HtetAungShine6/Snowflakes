//
//  JoinRoomView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/12/2024.
//

import SwiftUI

struct JoinRoomView: View {
    
    @State private var rotationAngle: Double = 0
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var roomCode: String = ""
    @State private var userName: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                
                rotatingSnowflakeIcon(size: min(geometry.size.width * 0.9, 290))
                    .padding(.bottom, -20)
                
                Text("Snowflake")
                    .font(Font.custom("Futura-Medium", size: 40).weight(.medium))
                    .foregroundColor(.black)
                    .padding(.top, -10)
                
                VStack(spacing: 20) {
                    roomCodeTextField
                    userNameTextField
                    confirmButton
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(Color(UIColor.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Action for the back button
                        navigationManager.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    @ViewBuilder
    private func rotatingSnowflakeIcon(size: CGFloat) -> some View {
        Circle()
            .foregroundColor(.clear)
            .frame(width: size, height: size)
            .background(
                Image("snowflake_icon")
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(Circle())
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
    }
    
    @ViewBuilder
    private func snowflakeIcon(size: CGFloat) -> some View {
        Circle()
            .foregroundColor(.clear)
            .frame(width: size, height: size)
            .background(
                Image("snowflake_icon")
                    .resizable()
                    .scaledToFit()
            )
            .clipShape(Circle())
    }
    
    private var roomCodeTextField: some View {
        TextField("Enter Room Code", text: $roomCode) //send the text to published var in view model /playground with get method
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: 18))
            .foregroundColor(.black)
            .keyboardType(.alphabet)
            .autocapitalization(.none)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }
    
    private var userNameTextField: some View {
        TextField("Enter Your Name", text: $userName) //send the text to published var in view model /playground with get method
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.custom("Roboto-Regular", size: 18))
            .foregroundColor(.black)
            .keyboardType(.default)
            .autocapitalization(.words)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
    }
    
    private var confirmButton: some View{
        Button {
            navigationManager.navigateTo(Destination.teamListPlayerView(roomCode: "123456"))
        }label: {
            HStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.white)
                    )
                    .padding(EdgeInsets(top: 6, leading: 9.5, bottom: 6, trailing: 9.5))
                
                Text("Join")
                    .font(Font.custom("Lato-Regular", size: 24))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                Spacer()
            }
            .frame(width: 246, height: 74)
            .background(Color(red: 0.69, green: 0.89, blue: 0.96))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }

}
