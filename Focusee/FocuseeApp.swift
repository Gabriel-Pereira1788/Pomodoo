//
//  FocuseeApp.swift
//  Focusee
//
//  Created by Gabriel Pereira on 07/01/25.
//

import SwiftUI

@main
struct FocuseeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
