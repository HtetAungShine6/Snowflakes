//
//  NavigationManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 30/11/2024.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isShopTime: Bool = false
    @Published var roomCode: String?
    @Published var playerRoomCode: String?
    @Published var currentRound: Int = 0
    @Published var totalRound: Int = 0

    func navigateTo(_ destination: Destination, roomCode: String? = nil, playerRoomCode: String? = nil) {
        path.append(destination)
    }

    func reset() {
        path.removeLast(path.count)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}


//class NavigationManager: ObservableObject {
//    @Published var path = NavigationPath()
//
//    func navigateTo<T>(_ destination: T) where T: Hashable {
//        path.append(destination)
//    }
//
//    func reset() {
//        path.removeLast(path.count)
//    }
//
//    func pop() {
//        if !path.isEmpty {
//            path.removeLast()
//        }
//    }
//}
