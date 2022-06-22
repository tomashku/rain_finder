//
//  rain_finderApp.swift
//  rain_finder
//
//  Created by Tomasz Zuczek on 22/06/2022.
//

import SwiftUI

@main
struct rain_finderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
