//
//  bloodmoonApp.swift
//  bloodmoon
//
//  Created by Daria Kolodzey on 2/19/21.
//

import SwiftUI

@main
struct bloodmoonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
