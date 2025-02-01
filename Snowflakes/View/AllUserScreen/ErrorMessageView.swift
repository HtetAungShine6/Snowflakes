import SwiftUI

struct ErrorMessageView: View {
    @Binding var showError: Bool
    var title: String = "Error"
    var message: String = "Something went wrong. Please try again."
    
    var body: some View {
        if showError {
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                    
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        withAnimation {
                            showError = false
                        }
                    }) {
                        Text("Dismiss")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 6)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: showError)
        }
    }
}

struct ErrorMessageView_Previews: PreviewProvider {
    @State static var showError: Bool = true
    
    static var previews: some View {
        ErrorMessageView(showError: $showError, title: "Oops!", message: "An unexpected error occurred. Please try again.")
    }
}
