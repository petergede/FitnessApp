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
            
            NewPointAdditionView()
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
            NewPointAdditionView()
                .tag("Add point")
                .tabItem {Image(systemName: "mappin.and.ellipse")
                }
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
            .environmentObject(HealthManager())
    }
}
