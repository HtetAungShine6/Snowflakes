//
//  TimerUnitView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 24/11/2024.
//

import SwiftUI

struct TimerUnitView: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(alignment: .center) {
            Text(String(format: "%02d", value))
                .font(.custom("Montserrat-Medium", size: 32))
                .foregroundColor(.black)
            Text(label)
                .font(.custom("Roboto-Light", size: 28))
                .foregroundColor(.black.opacity(0.8))
        }
    }
}

#Preview {
    TimerUnitView(value: 10, label: "hour")
}
