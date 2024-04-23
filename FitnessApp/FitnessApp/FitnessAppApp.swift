//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 3/4/24.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            FitnessView()
                .environmentObject(manager)
        }
    }
}
