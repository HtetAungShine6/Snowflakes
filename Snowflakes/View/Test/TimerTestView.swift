//
//  TimerTestView.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/12/2024.
//

import SwiftUI

struct TimerTestView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    
    var body: some View {
        VStack {
            // Connection Status
            Text(webSocketManager.isConnected ? "Connected" : "Disconnected")
                .font(.title)
                .foregroundColor(webSocketManager.isConnected ? .green : .red)
                .padding()
            
            // Countdown display
            if webSocketManager.isConnected {
                Text("Countdown: \(webSocketManager.countdown)")
                    .font(.headline)
                    .padding()
            }
            
            // Connect and Disconnect buttons
            HStack {
                Button(action: {
                    webSocketManager.connect()
                }) {
                    Text("Connect")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    webSocketManager.disconnect()
                }) {
                    Text("Disconnect")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            // Send Message button
            Button(action: {
                let message: [String: Any] = [
                    "arguments": [11],
                    "target": "StartTimer",
                    "type": 1
                ]
                webSocketManager.sendMessage(message)
            }) {
                Text("Send Message")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(!webSocketManager.isConnected)
        }
        .padding()
    }
}




//struct TimerTestView: View {
//    @StateObject private var webSocketManager = WebSocketManager()
//    @State private var countdown: Int = 0  // Track the countdown value
//    @State private var isTimerRunning: Bool = false  // Flag to check if the timer is running
//    
//    var body: some View {
//        VStack {
//            Text("WebSocket Message: \(webSocketManager.message)")
//                .padding()
//            
//            Text(webSocketManager.isConnected ? "Connected ✅" : "Disconnected ❌")
//                .padding()
//
//            Text("Countdown: \(countdown)")  // Display the countdown
//                .font(.largeTitle)
//                .padding()
//            
//            HStack {
//                Button("Connect to WebSocket") {
//                    webSocketManager.connect()
//                }
//                .padding()
//
//                Button("Disconnect from WebSocket") {
//                    webSocketManager.disconnect()
//                }
//                .padding()
//
//                Button("Send Message") {
//                    // Send the StartTimer message with 5 seconds
//                    webSocketManager.sendMessage([
//                        "arguments": [5],
//                        "target": "StartTimer",
//                        "type": 1
//                    ])
//                }
//                .padding()
//                .disabled(isTimerRunning)  // Disable the button when the timer is running
//            }
//        }
//        .onReceive(webSocketManager.$message) { message in
//            handleWebSocketMessage(message)
//        }
//    }
//    
//    // Handle the WebSocket message and trigger countdown logic
//    private func handleWebSocketMessage(_ message: String) {
//        guard let data = message.data(using: .utf8),
//              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//              let type = json["type"] as? Int,
//              type == 1,  // Ensure the message is a TimerUpdate message
//              let arguments = json["arguments"] as? [Int],
//              let countdownValue = arguments.first else {
//            return
//        }
//        
//        // Update countdown value based on received message
//        if countdownValue >= 0 {
//            countdown = countdownValue
//            if countdown > 0 {
//                startCountdown()
//            } else {
//                stopTimer()
//            }
//        }
//    }
//
//    private func startCountdown() {
//        isTimerRunning = true
//        
//        // Start the countdown timer
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            if countdown > 0 {
//                countdown -= 1
//            } else {
//                timer.invalidate()  // Stop the timer when it reaches 0
//                isTimerRunning = false
//            }
//        }
//    }
//    
//    private func stopTimer() {
//        isTimerRunning = false
//    }
//}
//
//struct TimerTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerTestView()
//    }
//}
//
