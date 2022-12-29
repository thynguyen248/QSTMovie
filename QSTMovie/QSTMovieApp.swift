//
//  QSTMovieApp.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/29/22.
//

import SwiftUI

@main
struct QSTMovieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
