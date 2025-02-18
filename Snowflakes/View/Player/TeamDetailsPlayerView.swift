import SwiftUI

struct TeamDetailsPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var team: TeamMockUp
    var members: [String]
    
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())] //
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            
            teamLabel
            
            // Player Cards Grid
            VStack(alignment: .leading, spacing: 20) {
                
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(members.indices, id: \.self) { index in
                        playerCardView(playerName: members[index], playerNumber: index + 1)
                    }
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
            
            Text("Waiting for host to start..")
                .font(Font.custom("Lato", size: 20).weight(.medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 0) 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Team Label (Replaced Section)
    private var teamLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Team: \(team.teamNumber)")
                    .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("\(team.tokens) tokens")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
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
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Player Card View
    private func playerCardView(playerName: String, playerNumber: Int) -> some View {
        VStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 133, height: 173)
                .background(Color(red: 0.69, green: 0.89, blue: 0.96))
                .cornerRadius(20)
                .opacity(0.70)
                .overlay(
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        
                        Text("Player \(playerNumber)")
                            .font(Font.custom("Inter", size: UIFont.preferredFont(forTextStyle: .callout).pointSize).weight(.bold))
                            .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        
                        Text(playerName)
                            .font(Font.custom("Inter", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize).weight(.medium))
                            .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                    }
                )
        }
        .frame(width: 133, height: 173)
    }
}

#Preview {
    TeamDetailsPlayerView(
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
