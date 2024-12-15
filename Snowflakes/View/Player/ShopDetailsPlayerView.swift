import SwiftUI

struct ShopDetailsPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var team: TeamMockUp
    var members: [String]
    
    @State private var notifications: [NotificationItem] = [
        NotificationItem(message: "You purchased Pen (x2) and Paper (x3)", amount: 10, color: Color.white, isChecked: false),
        NotificationItem(message: "You purchased Pen (x1) and Paper (x1)", amount: 5, color: Color.white, isChecked: false),
        NotificationItem(message: "You have received 5 Dollars by selling snowflake.", amount: 5, color: Color.white, isChecked: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Back button and Team label outside the ScrollView
            backButton
            teamLabel
            
            ScrollView { // ScrollView wraps only the scrollable content
                VStack(alignment: .leading, spacing: 20) {
                    items
                    
                    notificationList
                    
                    uploadImageSection // Add Upload Image section here
                    
                    Spacer() // Push everything to the top
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .background(Color.white)
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Back Button (Private Function)
    private var backButton: some View {
        Button(action: {
            navigationManager.pop()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
        }
        .padding(.leading, 10)
        .padding(.top, 10)
    }
    
    // MARK: - Team Label (Private Function)
    private var teamLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Bold", size: 20))
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: 15))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: 15))
                }
            }
            Spacer()
            ForEach(team.items.keys.sorted().reversed(), id: \.self) { itemName in
                VStack {
                    Image(itemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("\(team.items[itemName] ?? 0)x")
                        .font(.custom("Lato-Regular", size: 16))
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Items List
    private var items: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Buy")
                    .font(.custom("Lato", size: 22).weight(.medium))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(shopItems, id: \.title) { item in
                        PlayerShopItemView(imageName: item.imageName, title: item.title)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Notification List
    private var notificationList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notifications")
                .font(Font.custom("Lato", size: 22).weight(.medium))
                .foregroundColor(.black)
                .padding(.bottom, 10) // Padding between title and notifications
            
            ScrollView {
                ForEach(notifications.indices, id: \.self) { index in
                    let notification = notifications[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(notification.message)
                                .font(Font.custom("Poppins", size: 13))
                                .foregroundColor(.black)
                                .lineLimit(2) // Ensures message doesn't overflow
                            
                            Text("Total amount: \(notification.amount) tokens")
                                .font(Font.custom("Poppins", size: 10))
                                .tracking(1.5)
                                .foregroundColor(.black)
                                .opacity(0.65) // Slightly less opaque for less emphasis
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Toggle the isChecked property to change the background color
                            notifications[index].isChecked.toggle()
                            // Set the color based on the isChecked value
                            notifications[index].color = notifications[index].isChecked ? AppColors.frostBlue : Color.white
                        }) {
                            Image(systemName: notifications[index].isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(notifications[index].isChecked ? Color.green : Color.gray)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(notification.color) // Background color that changes based on isChecked
                    .cornerRadius(12)
                    .shadow(radius: 5, x: 0, y: 2)
                    .frame(height: 55)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Upload Image Section
    private var uploadImageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sell your Snowflake")
                .font(Font.custom("Lato", size: 22).weight(.medium))
                .foregroundColor(.black)
            
            // Horizontal Scroll View for Images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    // Placeholder images or your own images
                    ForEach(0..<5, id: \.self) { _ in
                        ZStack {
                            // Card style background with opacity
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 199, height: 238)
                                .background(Color.white.opacity(0.50)) // Adjust opacity for desired effect
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0.25) // Border for the card
                                )
                            
                            // Placeholder text for the image (replace with actual image later)
                            Text("Upload Pic")
                                .font(Font.custom("Lato", size: 20).weight(.medium))
                                .foregroundColor(.black)
                        }
                        .padding(3) // Padding around each card
                    }
                }
            }
            .frame(height: 238) // Set height for the horizontal scroll view
        }
        .padding(.horizontal, 10)
    }
    
}

#Preview {
    ShopDetailsPlayerView(
        team: TeamMockUp(
            teamNumber: 1,
            code: 1234,
            playersCount: 4,
            items: ["scissors": 2, "paper": 1, "pen": 3],
            tokens: 50,
            members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"]
        ),
        members: ["Hein Thant", "Thu Yein", "Htet Aung Shine"] // Example members
    )
    .environmentObject(NavigationManager())
}
