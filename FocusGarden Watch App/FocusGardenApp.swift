//
//  FocusGardenApp.swift
//  FocusGarden Watch App
//
//  Created by Claude
//

import SwiftUI

@main
struct FocusGarden_Watch_App: App {
    @StateObject private var watchViewModel = WatchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchViewModel)
        }
    }
}
