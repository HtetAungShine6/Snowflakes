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
            CreateTeamView(
                VM: CreateTeamViewModel(
                                teamNumber: 4,
                                maxMembers: 5,
                                tokens: 5,
                                isLoading: true
                            )
                        )
        }
    }
}
