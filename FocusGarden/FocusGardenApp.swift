//
//  FocusGardenApp.swift
//  FocusGarden
//
//  Created by Claude
//

import SwiftUI

@main
struct FocusGardenApp: App {
    @StateObject private var appViewModel = AppViewModel()

    init() {
        // Request notification permissions on app launch
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .onAppear {
                    // Remove any delivered notifications when app opens
                    NotificationManager.shared.removeAllDeliveredNotifications()
                }
        }
    }
}
