import SwiftUI
//import GoogleSignIn

struct SigninView: View {
    @State private var rotationAngle: Double = 0
//    @StateObject private var googleService = GoogleService()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()

                rotatingSnowflakeIcon(size: min(geometry.size.width * 0.9, 310))

                Text("Welcome to Snowflake")
                    .font(Font.custom("Manrope-Bold", size: 50))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                VStack(spacing: 20) {
                    signInButton

                    Text("or")
                        .font(Font.custom("Roboto-Medium", size: 18))
                        .foregroundColor(Color.gray)

                    joinRoomButton
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
        }
    }

    // MARK: - Rotating Snowflake Icon
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
    

    // MARK: - Sign-In Button
    private var signInButton: some View {
        Button(action: {
//            googleService.signIn()
        }) {
            HStack(spacing: 10) {
                Image("ios_light_rd_na")
                    .resizable()
                    .frame(width: 24, height: 24)

                Text("Sign In with Google")
                    .font(Font.custom("Roboto-Medium", size: 20))
                    .foregroundColor(AppColors.FontColor.opacity(0.545))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.lightGray)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 50)
        }
    }

    // MARK: - Join Room Button
    private var joinRoomButton: some View {
        Button(action: {
            // Action for joining a room
        }) {
            HStack(spacing: 10) {
                Image("Join_room")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)

                Text("Join a room to play")
                    .font(Font.custom("Roboto-Medium", size: 20))
                    .foregroundColor(AppColors.FontColor.opacity(0.545))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.lightGray)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5) 
            .padding(.horizontal, 50)
        }
    }
}

// MARK: - Preview
struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
