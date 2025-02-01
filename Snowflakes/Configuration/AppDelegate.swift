//
//  AppDelegate.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 19/11/2024.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    //MARK: - Initializing code for Firebase (App Configuration)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        return true
    }
}

//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
