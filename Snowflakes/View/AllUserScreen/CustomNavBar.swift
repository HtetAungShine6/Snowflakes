//
//  CustomNavBar.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct CustomNavBar: View {
    var title: String
    var subtitle: String
    var buttonImageName: String
    var buttonAction: () -> Void

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("Montserrat-Medium", size: 32))
                    .foregroundStyle(Color.black)
                Text(subtitle)
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Button(action: buttonAction) {
                Image(buttonImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomNavBar(title: "Snowflake",
                 subtitle: "Round (1/5)",
                 buttonImageName: "shop2") {
        print("Button tapped")
    }
}
