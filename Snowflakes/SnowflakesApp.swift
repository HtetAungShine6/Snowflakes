//
//  SnowflakesApp.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 04/11/2024.
//

import SwiftUI

@main
struct SnowflakesApp: App {
    var body: some Scene {
        WindowGroup {
                        HostTimerView(navBarTitle: "Snowflake", navBarSubtitle: "Round", image: Image("Snowman"))
        }
    }
}
