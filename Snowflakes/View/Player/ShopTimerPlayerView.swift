import SwiftUI

struct ShopTimerPlayerView: View {
    
//    @EnvironmentObject var navigationManager: NavigationManager
    
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
                Spacer() // Push everything down initially
                
                // The text to be moved to the top
                Text("It is time to sell a snow flake.")
                    .font(Font.custom("Lato", size: 36).weight(.medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .top) // Full width and align to top
                
                Spacer() // Fill the remaining space
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Ensure it sticks to the top
        }
        .onAppear(perform: loadData) // Correctly placed onAppear modifier
    }
    
    private var adjustTimeComponent: some View {
        VStack(alignment: .leading) {
            Text("Adjust Time")
                .font(.headline) // Optional: Add a font style
        }
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
    ShopTimerPlayerView(navBarTitle: "Loading...", navBarSubtitle: "Please wait", image: Image(systemName: "hourglass"))
}
