//
//  EventsView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 8/4/24.
//

import SwiftUI

struct FeaturedEventsResponse: Codable {
    let featuredEvents: [Event]
}

struct Event: Codable, Identifiable {
    let id = UUID()
    var name: String
    var url: String
    var permalink: String
    var date: String
    var city: String
    var country: String
    var location: String
    var price: String
    var sports: String
    var reviewsOverview: ReviewsOverview
    var titleImage: TitleImage
}

struct ReviewsOverview: Codable {
    var total: Int
    var average: Double
}

struct TitleImage: Codable {
    var key: String
    var base64: String
}

struct EventsView: View {
    @ObservedObject var viewModel = EventManager()
    
    
    var body: some View {
        VStack {
            List(viewModel.events) { event in
                HStack {
                    // Display the image
                    Base64ImageView(base64String: event.titleImage.base64)
                        .frame(width: 100, height: 100)
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text(event.date)
                            .font(.subheadline)
                        // Include other event details as desired
                    }
                }
            }
            
            Button(action: {
                viewModel.toggleEvents()
            }) {
                Text(viewModel.showingRecommended ? "Show All Events" : "Show Recommended Events")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            viewModel.fetchEvents() // Load the initial dataset when the view appears
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View{
        EventsView()
            .environmentObject(HealthManager())
    }
}
