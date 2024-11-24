import SwiftUI

struct TimerView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var timerActive = false
    @State private var timerPaused = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            // Timer Display
            HStack {
                Text(String(format: "%02d", hours))
                    .font(.largeTitle)
                    .frame(width: 60)
                Text(":")
                    .font(.largeTitle)
                Text(String(format: "%02d", minutes))
                    .font(.largeTitle)
                    .frame(width: 60)
                Text(":")
                    .font(.largeTitle)
                Text(String(format: "%02d", seconds))
                    .font(.largeTitle)
                    .frame(width: 60)
            }
            
            // Buttons
            VStack(spacing: 20) {
                Button(action: startTimer) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: pauseTimer) {
                    Text("Pause")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: resumeTimer) {
                        Text("Resume")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                Button(action: deleteTimer) {
                        Text("Delete")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            .padding()
        }
    }
    // Start Timer
    func startTimer() {
        resetTimer()
        timerActive = true
        timerPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            incrementTimer()
        }
    }

    // Pause Timer
    func pauseTimer() {
        timer?.invalidate()
        timerPaused = true
    }

    // Resume Timer
    func resumeTimer() {
        if timerPaused {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                incrementTimer()
            }
            timerPaused = false
        }
    }

    // Delete Timer (Reset and Stop)
    func deleteTimer() {
        resetTimer()
        timerActive = false
        timerPaused = false
    }

    // Reset Timer
    func resetTimer() {
        timer?.invalidate()
        hours = 0
        minutes = 0
        seconds = 0
    }

    // Increment Timer Logic
    func incrementTimer() {
        seconds += 1
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        if minutes == 60 {
            minutes = 0
            hours += 1
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
