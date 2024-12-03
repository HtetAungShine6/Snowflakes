//
//  GoogleService.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/11/2024.
//

import Foundation
import GoogleSignIn

class GoogleService: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""

    init() {
        restoreSession()
    }

    // Sign In with Google
    func signIn() {
        let signInConfig = GIDConfiguration(clientID: "739611732879-embu4vfhgb86d3p24042576nbsccccg8.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Sign-in failed: \(error.localizedDescription)"
                return
            }
            guard let user = authResult?.user else { return }

            // Save tokens using TokenManager
            if let idToken = user.idToken?.tokenString {
                TokenManager.shared.saveIDToken(idToken)
                print("idToken: \(idToken)")
            } else {
                print("Cannot get idToken")
            }

            let accessToken = user.accessToken.tokenString
            TokenManager.shared.saveAccessToken(accessToken)
            print("Access Token: \(accessToken)")

            self?.isLoggedIn = true
        }
    }

    // Sign Out from Google
    func signOut() {
        GIDSignIn.sharedInstance.signOut()

        // Clear tokens using TokenManager
        TokenManager.shared.deleteIDToken()
        TokenManager.shared.deleteAccessToken()

        isLoggedIn = false
    }

    // Restore Session and check for token expiration
    func restoreSession() {
        // Check if an ID token exists in the Keychain
        if let idToken = TokenManager.shared.getIDToken() {
            // Optionally validate the ID token
            print("Restored ID Token: \(idToken)")
            
            // Retrieve and check if the access token has expired
            checkTokenExpiration()
        } else {
            self.isLoggedIn = false
        }
    }

    // Check if the Access Token is expired
    func checkTokenExpiration() {
        // Retrieve the access token from the Keychain
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            self.isLoggedIn = false
            print("No Access Token found, logging out.")
            return
        }

        // Make a network call or use a library to validate the token's expiration.
        // For example, you can decode the access token if it's a JWT and check its expiration date.
        
        // In case Google API already provides an expiration date in the token
        // (or you have access to it through user data or API calls), you can check it here.
        
        // If the access token has expired, log out
        let tokenExpirationDate = getTokenExpirationDate(   from: accessToken)
        
        if tokenExpirationDate < Date() {
            // Token has expired, log out
            print("Access Token has expired, logging out.")
            signOut()
        } else {
            // Token is still valid, keep the user logged in
            self.isLoggedIn = true
            print("Access Token is still valid, user is logged in.")
        }
    }

    // A method to decode the token and extract expiration (just an example for JWT).
    // You can use a JWT decoding library or decode it manually.
    func getTokenExpirationDate(from accessToken: String) -> Date {
        // This is just an example. The actual implementation will depend on the format of the token
        // For a JWT, you would decode the token and check its "exp" field.
        
        // Example decoding (This is just a placeholder, you'll need to implement decoding logic based on your token format).
        let components = accessToken.split(separator: ".")
        guard components.count > 1 else { return Date() }

        let payload = components[1]
        guard let decodedData = Data(base64Encoded: String(payload)) else { return Date() }

        // Convert the decoded data to a JSON object (assuming it's a JWT).
        if let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
           let jsonDict = json as? [String: Any],
           let expTimestamp = jsonDict["exp"] as? TimeInterval {
            return Date(timeIntervalSince1970: expTimestamp)
        }

        return Date() // Default to now if we can't extract the expiration.
    }

    // Debug function to print tokens
    func debugPrintTokens() {
        if let idToken = TokenManager.shared.getIDToken() {
            print("ID Token: \(idToken)")
        } else {
            print("No ID Token found.")
        }

        if let accessToken = TokenManager.shared.getAccessToken() {
            print("Access Token: \(accessToken)")
        } else {
            print("No Access Token found.")
        }
    }
}


//class GoogleService: ObservableObject {
//    
//    @Published var isLoggedIn: Bool = false
//    @Published var errorMessage: String = ""
//    
//    init() {
//        restorePreviousSignIn()
//    }
//    
//    /// Restore previous sign-in state
//    func restorePreviousSignIn() {
//        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
//            if let error = error {
//                self?.errorMessage = "Error: \(error.localizedDescription)"
//                self?.isLoggedIn = false
//            } else {
//                self?.updateSignInStatus(user: user)
//            }
//        }
//    }
//    
//    /// Sign in the user
//    func signIn() {
//        let signInConfig = GIDConfiguration(clientID: "739611732879-embu4vfhgb86d3p24042576nbsccccg8.apps.googleusercontent.com")
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] authResult, error in
//            if let error = error {
//                self?.errorMessage = "Sign-in failed: \(error.localizedDescription)"
//                return
//            }
//            
//            // Successful sign-in
//            guard let user = authResult?.user else {
//                self?.errorMessage = "Sign-in failed: Unable to retrieve user."
//                return
//            }
//            
//            self?.updateSignInStatus(user: user)
//        }
//    }
//    
//    /// Sign out the user
//    func signOut() {
//        GIDSignIn.sharedInstance.signOut()
//        self.isLoggedIn = false
//        print("User signed out.")
//    }
//    
//    /// Update sign-in status
//    private func updateSignInStatus(user: GIDGoogleUser?) {
//        if let user = user {
//            self.isLoggedIn = true
//            self.errorMessage = ""
//            print("Signed in as: \(user.profile?.name ?? "Unknown User")")
//        } else {
//            self.isLoggedIn = false
//            self.errorMessage = "User is not signed in."
//        }
//    }
//}


>>>>>>> 995e6d5 (Sprint 2)
//class GoogleService: ObservableObject {
//    
//    @Published var errorMessage = ""
//    
//    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Error?, Bool) -> Void) {
//        
//        guard let clientID = FirebaseManager.shared.firebaseApp?.options.clientID else {
//            self.errorMessage = "Missing Firebase Client ID"
//            DispatchQueue.main.async {
//                completion(NSError(domain: "GoogleAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Firebase client ID."]), false)
//            }
//            return
//        }
//        
//        let config = GIDConfiguration(clientID: clientID)
//        
<<<<<<< HEAD
//        GIDSignIn.sharedInstance.configuration = config3
=======
//        GIDSignIn.sharedInstance.configuration = config
>>>>>>> 995e6d5 (Sprint 2)
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
//            
//            if let error = error {
//                self.errorMessage = "Failed to sign in with instance: \(error.localizedDescription)"
//                DispatchQueue.main.async {
//                    completion(error, false)
//                }
//            }
//            
//            guard let user = user?.user, let idToken = user.idToken else {
//                DispatchQueue.main.async {
//                    completion(nil, false)
//                }
//                return
//            }
//            
//            let accessToken = user.accessToken
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            
//            FirebaseManager.shared.auth.signIn(with: credential) { authResult, error in
//                
//                if let error = error {
//                    self.errorMessage = "Failed to sign in with error: \(error.localizedDescription)"
//                    DispatchQueue.main.async {
//                        completion(nil, false)
//                    }
//                    return
//                }
//                
//                guard let authResult = authResult else {
//                    self.errorMessage = "Authentication result is nil: \(String(describing: error))"
//                    DispatchQueue.main.async {
//                        completion(NSError(domain: "FirebaseAuthError", code: -1, userInfo: nil), false)
//                    }
//                    return
//                }
//                
//                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
//                
//                if isNewUser {
//                    // call sign up route here
//                    completion(nil, true)
//                } else {
//                    // call sign in route here
//                    completion(nil, true)
//                }
//            }
//        }
//    }
//    
//    func signOutWithGoogle() {
//        do {
//            try FirebaseManager.shared.auth.signOut()
//        } catch let signOutError as NSError {
//            self.errorMessage = "Failed to sign out with error: \(signOutError)"
//        }
//    }
//}
