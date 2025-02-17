//
//  ImageUploadManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 17/2/25.
//

import SwiftUI

class UploadImageViewModel: ObservableObject {
    
    @Published var uploadSuccess = false
    @Published var isUploading = false
    @Published var errorMessage: String?
    
    func uploadImage(_ image: UIImage, teamId: String) {
        guard let url = URL(string: "https://snowflakeapi-bkd0aygebke4fscg.southeastasia-01.azurewebsites.net/api/image?teamId=\(teamId)") else {
            print("Invalid URL")
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            return
        }

        // Construct the multipart request body
        var body = Data()
        let fileName = "uploaded_image.jpg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Upload Task
        isUploading = true
        uploadSuccess = false
        errorMessage = nil

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isUploading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Upload failed: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Server error: Invalid response"
                }
                return
            }
            
            DispatchQueue.main.async {
                self.uploadSuccess = true
                print("Upload successful!")
            }
        }.resume()
    }
}
