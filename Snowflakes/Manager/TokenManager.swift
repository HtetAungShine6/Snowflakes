//
//  TokenManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 27/11/2024.
//

import Security
import Foundation

class TokenManager {
    static let shared = TokenManager()

    private init() {} // Singleton pattern

    private let idTokenKey = "id_token"
    private let accessTokenKey = "access_token"

    // Save token securely in Keychain
    func saveToken(_ token: String, for key: String) {
        let data = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // Delete existing token if present
        SecItemAdd(query as CFDictionary, nil)
    }

    // Retrieve token securely from Keychain
    func getToken(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr,
           let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    // Delete token securely from Keychain
    func deleteToken(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }

    // Save ID Token
    func saveIDToken(_ token: String) {
        saveToken(token, for: idTokenKey)
    }

    // Retrieve ID Token
    func getIDToken() -> String? {
        return getToken(for: idTokenKey)
    }

    // Delete ID Token
    func deleteIDToken() {
        deleteToken(for: idTokenKey)
    }

    // Save Access Token
    func saveAccessToken(_ token: String) {
        saveToken(token, for: accessTokenKey)
    }

    // Retrieve Access Token
    func getAccessToken() -> String? {
        return getToken(for: accessTokenKey)
    }

    // Delete Access Token
    func deleteAccessToken() {
        deleteToken(for: accessTokenKey)
    }
}
