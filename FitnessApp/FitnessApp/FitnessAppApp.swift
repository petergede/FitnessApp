//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 3/4/24.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct FitnessAppApp: App {
    @StateObject var manager = HealthManager()
    @StateObject var iconNames = IconNames()
    @StateObject var viewModel = AuthViewModel()
    let persistenceController = PersistenceController.shared
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environmentObject(iconNames)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
