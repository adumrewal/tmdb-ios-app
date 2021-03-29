//
//  TMDB_sample_appApp.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 29/03/21.
//

import SwiftUI

@main
struct TMDB_sample_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
