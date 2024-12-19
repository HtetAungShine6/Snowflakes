//
//  WebSocketManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 15/12/2024.
//


import SwiftUI
import Starscream

class WebSocketManager: ObservableObject, WebSocketDelegate {
    private var socket: WebSocket!
    @Published var message: String = ""
    @Published var isConnected: Bool = false
    @Published var countdown: Int = 0
    
    var countdownTimer: Timer?
    
    init() {
        // Ensure you use the correct URL for your SignalR hub
        var request = URLRequest(url: URL(string: "wss://snowflakeapi-bkd0aygebke4fscg.southeastasia-01.azurewebsites.net/timer-hub?negotiateVersion=1")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
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
                jsonString.append("\u{1e}") // Append Record Separator (RS) at the end (important for SignalR)
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
            print("Text message received: \(text)")
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
    
    // Handle incoming WebSocket response
    private func handleWebSocketResponse(text: String) {
        // Remove the SignalR message delimiter \u{1E} from the end of the message
        let cleanedText = text.trimmingCharacters(in: .controlCharacters)
        print("Cleaned response: \(cleanedText)")
        
        if let data = cleanedText.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(WebSocketResponse.self, from: data)
                if let countdownValue = response.arguments.first {
                    DispatchQueue.main.async{
                        self.countdown = countdownValue
                    }
                }
            } catch {
                print("Failed to parse WebSocket response: \(error.localizedDescription)")
            }
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


