//
//  DestinationManager.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 02/12/2024.
//

import SwiftUI

enum Destination: Hashable {
    case hostSettingView
    case teamListView(roomCode: String)
    case hostTimerView(title: String, subtitle: String, imageName: String)
    case hostShopView
    // Add more cases as needed
}
