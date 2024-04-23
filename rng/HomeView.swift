//
//  HomeView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 3/4/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    let welcomeArray = ["Welcome","Καλησπέρα"]
    @State private var currentIndex = 0
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Welcome")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .onAppear{
                    startWelcomeTimer()
                }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing:20), count: 2)) {
                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }),
                        id: \.key){ item in
                    ActivityCard(activity: item.value)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity, alignment: .top)
        
    }
    
    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View{
        HomeView()
    }
}
