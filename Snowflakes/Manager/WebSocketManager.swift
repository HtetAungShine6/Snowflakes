//
//  WebSocketManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/12/2024.
//

import SwiftUI
import Starscream
import AVFoundation
import UserNotifications

class WebSocketManager: ObservableObject, WebSocketDelegate {
    
    private var socket: WebSocket!
    @Published var message: String = ""
    @Published var isConnected: Bool = false
    @Published var countdown: String = ""
    @Published var messageFromHost: String = ""
    @Published var userJoined: Bool = false
    @Published var timerCreated: Bool = false
    @Published var timerStarted: Bool = false
    @Published var timerPaused: Bool = false
    @Published var timerResumed: Bool = false
    @Published var timerStopped: Bool = false
    @Published var targetValue: String = ""
    @Published var socketMessage: String = ""
    @Published var addedTimer: String = ""
    @Published var roomCode: String = ""
    @Published var currentGameState: String = ""
    
    var countdownTimer: Timer?
    var audioPlayer: AVAudioPlayer?
    
    static let shared = WebSocketManager()
    
    init() {
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
        
        // Ensure you use the correct URL for your SignalR hub
        var request = URLRequest(url: URL(string: "wss://snowflakeapi-bkd0aygebke4fscg.southeastasia-01.azurewebsites.net/timer-hub")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }
    
    // Connect to the WebSocket and send the handshake request
    func connect() {
        socket.connect()
    }
    
    // Disconnect from the WebSocket
    func disconnect() {
        socket.disconnect()
    }
    
    // Send a message through the WebSocket
    func sendMessage(_ message: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            if var jsonString = String(data: jsonData, encoding: .utf8) {
                jsonString.append("\u{1e}")
                socket.write(string: jsonString)
                print("Sent message: \(jsonString)")
            }
        } catch {
            print("Failed to convert message to JSON: \(error.localizedDescription)")
        }
    }
    
    // REQUIRED: Handle WebSocket events
    func didReceive(event: WebSocketEvent, client: any WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("Connected to WebSocket with headers: \(headers)")
            isConnected = true
            
            // ** Send handshake message after connecting **
            sendHandshake()
            
        case .disconnected(let reason, let code):
            print("Disconnected from WebSocket: \(reason) with code: \(code)")
            isConnected = false
            
        case .text(let text):
            handleWebSocketResponse(text: text)
            
        case .binary(let data):
            print("Binary data received: \(data.count) bytes")
            
        case .ping(_):
            print("Ping received from server")
            
        case .pong(_):
            print("Pong received in response to ping")
            
        case .viabilityChanged(let isViable):
            print("Viability changed. Is connection viable? \(isViable)")
            
        case .reconnectSuggested(let shouldReconnect):
            print("Reconnect suggested: \(shouldReconnect)")
            if shouldReconnect {
                connect()
            }
            
        case .cancelled:
            print("WebSocket connection cancelled")
            isConnected = false
            
        case .error(let error):
            print("WebSocket encountered an error: \(error?.localizedDescription ?? "Unknown error")")
            
        case .peerClosed:
            print("Peer closed due to an error.")
        }
    }
    
    // Join a group
    func joinGroup(roomCode: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode],
            "target": "JoinGroup",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Send a message
    func messageSend(roomCode: String, message: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode, message],
            "target": "SendMessage",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Create a timer
    func createTimer(roomCode: String, socketMessage: String, gameState: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode, socketMessage, gameState],
            "target": "CreateTimer",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Start countdown
    func startCountdown(roomCode: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode],
            "target": "StartCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Pause countdown
    func pauseCountdown(roomCode: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode],
            "target": "PauseCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
        print("💕 Pause Timer called!!!!")
    }
    
    // Resume countdown
    func resumeCountdown(roomCode: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode],
            "target": "ResumeCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Add countdown
    func addCountdown(roomCode: String, socketMessage: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode, socketMessage],
            "target": "AddCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Minus countdown
    func minusCountdown(roomCode: String, socketMessage: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode, socketMessage],
            "target": "MinusCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Stop countdown
    func stopCountdown(roomCode: String) {
        let messageToSocket: [String: Any] = [
            "arguments": [roomCode],
            "target": "StopCountdown",
            "type": 1
        ]
        sendMessage(messageToSocket)
    }
    
    // Handle incoming WebSocket response
    private func handleWebSocketResponse(text: String) {
        // Log the raw response text
        print("Raw WebSocket response: \(text)")
        
        // Split the incoming text by the SignalR message delimiter
        let messages = text.components(separatedBy: "\u{1E}")
        
        for message in messages {
            // Trim whitespace and check if the message is not empty
            let cleanedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleanedMessage.isEmpty else { continue }
            
            if let data = cleanedMessage.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode(WebSocketResponse.self, from: data)
                    
                    if let target = response.target {
                        print("🎯\(target)🎯")
                        switch target {
                        case "ReceivedMessage":
                            print("ReceivedMessage passed✅")
                        case "JoinUser   Group":
                            self.userJoined = true
                            print("JoinUser   Group passed✅")
                        case "ReceiveMessage":
                            if let arguments = response.arguments?.first {
                                DispatchQueue.main.async {
                                    self.messageFromHost = arguments
                                    print("💌Message fetched: \(self.messageFromHost)")
                                }
                            }
                            print("SendMessage passed✅")
                        case "CreateTimer":
                            if let arguments = response.arguments, arguments.count > 0 {
                                let extractedGameState = arguments[0]
                                DispatchQueue.main.async {
                                    self.currentGameState = extractedGameState
                                    print("❤️GameState updated to: \(self.currentGameState)")
                                }
                            }
                            print("CreateTimer passed✅")
                        case "TimerStarted":
                            self.timerStarted = true
                            print("TimerStarted passed✅")
                        case "TimerUpdate":
                            print("TimerUpdate passed✅")
                            if let countdownValue = response.arguments?.first {
                                DispatchQueue.main.async {
                                    self.countdown = countdownValue
                                    print("Countdown updated to: \(self.countdown)")
                                    
                                    // Play custom sound when countdown reaches "00:00"
                                    if self.countdown == "00:00" {
                                        self.playSound(named: "snowflake_alert") // Play sound from assets
                                        print("Testing: Custom sound played✅")
                                    }
                                }
                            }
                        case "TimerPaused":
                            print("TimerPaused passed✅")
                            self.timerPaused = true
                            self.timerResumed = false
                        case "TimerModify":
                            print("TimerModify passed✅")
                        case "TimerResume":
                            print("TimerResume passed✅")
                            self.timerResumed = true
                            self.timerPaused = false
                        case "TimerStopped":
                            print("TimerStopped passed✅")
                            self.timerStarted = false
                        case "CountdownCompleted":
                            print("CountdownCompleted passed✅")
                            // Handle countdown completion logic here
                        default:
                            print("Unhandled target❌: \(target)")
                        }
                    }
                } catch {
                    print("Failed to parse WebSocket response: \(error.localizedDescription)")
                }
            }
        }
    }

    // Play sound from assets
    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    // Send the handshake message to initiate the connection
    private func sendHandshake() {
        let handshakeMessage = """
        {"protocol":"json","version":1}\u{1e}
        """
        socket.write(string: handshakeMessage)
        print("Sent handshake: \(handshakeMessage)")
    }
}
