//
//  AdjustTimeComponent.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 26/11/2024.
//

import SwiftUI

struct AdjustTimeComponent: View {
    @State private var time: String = "00:00"
    
    var onDecrease: (String) -> Void = { _ in }
    var onIncrease: (String) -> Void = { _ in }

    var body: some View {
        HStack {
            // Decrease Button
            Button(action: {
                decrementTime()
                onDecrease(time)
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 30, height: 30)
            .foregroundColor(AppColors.glacialBlue)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
            
            // Display Time (MM:SS)
            Text(time)
                .font(.custom("Roboto-Regular", size: 32))
                .foregroundStyle(Color.black)
                .frame(minWidth: 80)
            
            // Increase Button
            Button(action: {
                incrementTime()
                onIncrease(time)
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .frame(width: 30, height: 30)
            .foregroundColor(AppColors.glacialBlue)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
    
    private func incrementTime() {
        let components = time.split(separator: ":")
        if Int(components[0]) != nil {
            let newMinutes = 1
            time = String(format: "%02d:00", newMinutes)
        }
    }

    private func decrementTime() {
        let components = time.split(separator: ":")
        if let minuteValue = Int(components[0]), minuteValue > 0 {
            let newMinutes = max(minuteValue - 1, 0) 
            time = String(format: "%02d:00", newMinutes)
        }
    }
}


//struct AdjustTimeComponent: View {
//    @State private var minutes: Int = 0
//    @State private var seconds: Int = 0
//    
//    var onDecrease: (Int, Int) -> Void = { _, _ in }
//    var onIncrease: (Int, Int) -> Void = { _, _ in }
//
//    var body: some View {
//        HStack {
//            // Decrease Button
//            Button(action: {
//                decrementTime()
//                onDecrease(minutes, seconds)
//            }) {
//                Image(systemName: "minus")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 20, height: 20)
//            }
//            .frame(width: 30, height: 30)
//            .foregroundColor(AppColors.glacialBlue)
//            .padding()
//            .background(Color.white)
//            .clipShape(Circle())
//            .overlay(
//                Circle()
//                    .stroke(Color.black, lineWidth: 2)
//            )
//            
//            // Display Minutes and Seconds
//            Text(String(format: "%02d:%02d", minutes, seconds))
//                .font(.custom("Roboto-Regular", size: 32))
//                .foregroundStyle(Color.black)
//                .frame(minWidth: 80)
//            
//            // Increase Button
//            Button(action: {
//                incrementTime()
//                onIncrease(minutes, seconds)
//            }) {
//                Image(systemName: "plus")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 20, height: 20)
//            }
//            .frame(width: 30, height: 30)
//            .foregroundColor(AppColors.glacialBlue)
//            .padding()
//            .background(Color.white)
//            .clipShape(Circle())
//            .overlay(
//                Circle()
//                    .stroke(Color.black, lineWidth: 2)
//            )
//        }
//    }
//    
//    // Increment Time
//    private func incrementTime() {
//        if seconds == 59 {
//            seconds = 0
//            minutes += 1
//        } else {
//            seconds += 1
//        }
//    }
//
//    // Decrement Time
//    private func decrementTime() {
//        if minutes == 0 && seconds == 0 {
//            return // Prevent negative time
//        }
//        if seconds == 0 {
//            seconds = 59
//            minutes -= 1
//        } else {
//            seconds -= 1
//        }
//    }
//}
