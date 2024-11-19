//
//  GoogleService.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/11/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class GoogleService: ObservableObject {
    
    @Published var errorMessage = ""
    
    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Error?, Bool) -> Void) {
        
        guard let clientID = FirebaseManager.shared.firebaseApp?.options.clientID else {
            self.errorMessage = "Missing Firebase Client ID"
            DispatchQueue.main.async {
                completion(NSError(domain: "GoogleAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Firebase client ID."]), false)
            }
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            
            if let error = error {
                self.errorMessage = "Failed to sign in with instance: \(error.localizedDescription)"
                DispatchQueue.main.async {
                    completion(error, false)
                }
            }
            
            guard let user = user?.user, let idToken = user.idToken else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            FirebaseManager.shared.auth.signIn(with: credential) { authResult, error in
                
                if let error = error {
                    self.errorMessage = "Failed to sign in with error: \(error.localizedDescription)"
                    DispatchQueue.main.async {
                        completion(nil, false)
                    }
                    return
                }
                
                guard let authResult = authResult else {
                    self.errorMessage = "Authentication result is nil: \(String(describing: error))"
                    DispatchQueue.main.async {
                        completion(NSError(domain: "FirebaseAuthError", code: -1, userInfo: nil), false)
                    }
                    return
                }
                
                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                
                if isNewUser {
                    // call sign up route here
                    completion(nil, true)
                } else {
                    // call sign in route here
                    completion(nil, true)
                }
            }
        }
    }
    
    func signOutWithGoogle() {
        do {
            try FirebaseManager.shared.auth.signOut()
        } catch let signOutError as NSError {
            self.errorMessage = "Failed to sign out with error: \(signOutError)"
        }
    }
}
