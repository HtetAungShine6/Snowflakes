import SwiftUI

struct TeamDetailsPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var teamNumber: Int
    var balance: Int
    var scissorsCount: Int
    var paperCount: Int
    var penCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                navigationManager.pop()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
            }
            .padding(.top,0)
            .padding(.leading, 10)

            VStack(alignment: .leading, spacing: 30) {
                HStack(alignment: .top, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Team : \(teamNumber)")
                            .font(Font.custom("Lato", size: 20).weight(.bold))
                            .foregroundColor(.black)

                        Text("Balance : \(balance) tokens")  // Balance
                            .font(Font.custom("Lato", size: 12))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()

                    HStack(spacing: 1) {  // Adjusted spacing between tools
                        toolWithCount(iconName: "scissors", count: scissorsCount)
                        toolWithCount(iconName: "paper", count: paperCount)
                        toolWithCount(iconName: "pen", count: penCount)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }

    private func toolWithCount(iconName: String, count: Int) -> some View {
        VStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text("\(count)x")
                .font(Font.custom("Lato", size: 12).weight(.light))
                .foregroundColor(.black)
        }
        .frame(width: 50)
    }
}

struct TeamDetailsPlayerView_Previews: PreviewProvider {
    static var previews: some View {

        TeamDetailsPlayerView(teamNumber: 01, balance: 5, scissorsCount: 1, paperCount: 2, penCount: 3)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
