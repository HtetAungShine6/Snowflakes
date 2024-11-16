import SwiftUI

struct HostScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                
                snowflakeIcon(size: min(geometry.size.width * 0.9, 290))
                    .padding(.bottom, -20)
                
                Text("Snowflake")
                    .font(Font.custom("Futura-Medium", size: 40).weight(.medium))
                    .foregroundColor(.black)
                    .padding(.top, -10)
                
                VStack(spacing: 20) {
                    createRoomButton
                    joinRoomButton
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func snowflakeIcon(size: CGFloat) -> some View {
        Circle()
            .foregroundColor(.clear)
            .frame(width: size, height: size)
            .background(
                Image("snowflake_icon")  // Ensure you have this image in your assets
                    .resizable()
                    .scaledToFit()
            )
            .clipShape(Circle())
    }
    
    // MARK: - Create Room Button
    private var createRoomButton: some View {
        Button(action: { }) {
            HStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "snowflake")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.white)
                    )
                    .padding(EdgeInsets(top: 6, leading: 9.5, bottom: 6, trailing: 9.5))
                
                Text("Create a room")
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

    // MARK: - Join Room Button
    private var joinRoomButton: some View {
        Button(action: { }) {
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
                
                Text("Join a room")
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
    
    // MARK: - Preview
    struct HostScreenView_Previews: PreviewProvider {
        static var previews: some View {
            HostScreenView()
        }
    }
}
