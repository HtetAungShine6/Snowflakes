import SwiftUI

struct SigninView: View {
    @State private var rotationAngle: Double = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()

                Circle()
                    .foregroundColor(.clear)
                    .frame(width: min(geometry.size.width * 0.8, 290), height: min(geometry.size.height * 0.4, 282))
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

                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome to Snowflake")
                        .font(Font.custom("Manrope-Bold", size: 50))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .multilineTextAlignment(.leading)

                    Text("Where creativity meets teamwork to craft unique paper snowflakes. Join now and start creating!")
                        .font(Font.custom("Manrope-Medium", size: 20))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 30)

                Button(action: {
                    
                }) {
                    HStack {
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Sign In with Google")
                            .font(Font.custom("Manrope-Medium", size: 20))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal, 50)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
