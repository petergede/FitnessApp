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
                .environmentObject(manager)
                .tag("Home")
                .tabItem {
                    Image(systemName:"house")
                }
            
            ChartsView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem {
                    Image(systemName:"chart.line.uptrend.xyaxis")
                }
            
            LocationsMap()
                .environmentObject(manager)
                .tag("Map")
                .tabItem {
                    Image(systemName:"map.fill")
                }
            
            EventsView()
                .environmentObject(manager)
                .tag("Events")
                .tabItem {
                    Image(systemName:"calendar")
                }
            StadiumContentView()
                .tag("View Stadiums")
                .tabItem {
                    Label("Add point", systemImage: "mappin.and.ellipse")
                }
            ProfileView()
                .tag("Content")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            LocationListView()
                .tag("View locations")
                .tabItem {
                    Label("View locations", systemImage: "mappin.circle.fill")
                }
            FavoritesView()
                .tag("Favorite events")
                .tabItem {
                    Label("Favorite events", systemImage: "heart.fill")
                }
            SettingsView()
                .tag("Configure icon")
                .tabItem {
                    Label("Configure icon", systemImage: "gearshape")
                }
        }
    }
    
}

struct FitnessView_Previews: PreviewProvider {
    static var previews: some View{
        FitnessView()
            .environmentObject(HealthManager())
    }
}
