//
//  FitnessView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 3/4/24.
//

import SwiftUI

struct FitnessView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName:"house")
                }
                .environmentObject(manager)
            
            ContentView()
                .tag("Content")
                .tabItem {Image(systemName: "person")
                }
        }
    }
    
}

struct FitnessView_Previews: PreviewProvider {
    static var previews: some View{
        FitnessView()
    }
}
