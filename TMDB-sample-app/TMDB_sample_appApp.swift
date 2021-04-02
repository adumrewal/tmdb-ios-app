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
//        WindowGroup {
//            ContentViewDemo()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct TMDB_sample_appApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
