//
//  LocationListView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 24/4/24.
//

//MARK: NO USE
import SwiftUI
import SwiftData

struct LocationListView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var location: [Location]
    @State private var path = [Location]()
    
    var body: some View {
        VStack {
            Text("Tap on this button to add a location")
            Button("Add a test location") {
                addLocation()
            }
            NavigationStack(path: $path){
                List {
                    ForEach(location) { item in
                        NavigationLink(value: item) {
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.information)
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteLocation(location[index])
                        }
                    }
                }
                .navigationTitle("Locations")
                .navigationDestination(for: Location.self, destination: AddLocationView.init)
                .toolbar {
                    Button("Add location",systemImage: "plus",action: addNewLocation)
                }
            }
            .padding()
        }
    }

    func addLocation() {
        let location = Location(name: "Test Location", price: 10, information: "Information", lat: 32, lon: 35,associate: 0)
        // Add the item to the data context
         context.insert(location)
    }
    
    func addNewLocation() {
        let location = Location(name: "", price: 0, information: "", lat: 0, lon: 0,associate: 0)
        // Add the item to the data context
         context.insert(location)
         path = [location]
    }

    func deleteLocation(_ location: Location) {
        // Delete the item from the data context
         context.delete(location)
    }
    
    func updateLocation(_ location: Location) {
        location.name = "Update location"
        // Delete the item from the data context
        try? context.save()
    }
}


struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}

