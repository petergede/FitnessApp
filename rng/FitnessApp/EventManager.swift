//
//  EventManager.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 8/4/24.
//
import Combine
import SwiftUI

class EventManager: ObservableObject {
    @Published var events = [Event]()
    @Published var showingRecommended = false // Track the current dataset
    
    func fetchEvents() {
        guard let url = URL(string: "https://www.ahotu.com/api/search/getFeaturedEvents") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "locale": "en",
            "exceptPermalinks": [
                "crete-marathon",
                "rhodes-marathon-half",
                // Add other permalinks as needed
            ],
            "query": [:],
            "isRecommended": false
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode JSON body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Fetch error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FeaturedEventsResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.events = decodedResponse.featuredEvents
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        
        task.resume()
    }
    
    func fetchRecommendedEvents() {
        guard let url = URL(string: "https://www.ahotu.com/api/search/getFeaturedEvents") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "locale": "en",
            "exceptPermalinks": [
                "crete-marathon",
                "rhodes-marathon-half",
                // Add the rest of the permalinks
            ],
            "query": [
                "criteria": ["running", "greece"]
            ],
            "isRecommended": true
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode JSON body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Fetch error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FeaturedEventsResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.events = decodedResponse.featuredEvents
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        
        task.resume()
    }
    
    func toggleEvents() {
        if showingRecommended {
            fetchEvents() // Fetch the original list
        } else {
            fetchRecommendedEvents() // Fetch the recommended list
        }
        showingRecommended.toggle() // Switch the flag
    }
    
}


