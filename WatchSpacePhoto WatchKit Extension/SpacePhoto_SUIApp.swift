//
//  SpacePhoto_SUIApp.swift
//  WatchSpacePhoto WatchKit Extension
//
//  Created by Augusto Galindo Alí on 24/02/21.
//

import SwiftUI

@main
struct SpacePhoto_SUIApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
