//
//  AddLocationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 23/4/24.
//

//import SwiftUI
//


//CURRENTLY NOT USED AS MAIN VIEW

import SwiftUI
import CoreData
import FirebaseFirestore
//
struct AddLocationView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var selection: String? = nil
    
    @State private var name: String = ""
    @State private var price: Double = 0.0
    @State private var information: String = ""
    @State private var lat: Double = 0.0
    @State private var lon: Double = 0.0
    @State private var associate: Int = 0
    @EnvironmentObject var viewModel: AuthViewModel
    
    var location: Location? // Optional to handle new or existing locations
    
    init(location: Location?) {
        self.location = location
        if let location = location {
            _name = State(initialValue: location.name)
            _price = State(initialValue: location.price)
            _information = State(initialValue: location.information)
            _lat = State(initialValue: location.lat)
            _lon = State(initialValue: location.lon)
            _associate = State(initialValue: location.associate)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name New", text: $name)
                TextField("Price", value: $price, formatter: NumberFormatter())
                TextField("Information", text: $information)
                TextField("Latitude", value: $lat, formatter: NumberFormatter())
                TextField("Longitude", value: $lon, formatter: NumberFormatter())
                Section("Associate New"){
                    Picker("Associate",selection: $associate) {
                        Text("Yava").tag(1)
                        Text("Fintess Club").tag(2)
                        Text("Interntional Club").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                Button("Add Location") {
                    Task {
                        do {
                            try await viewModel.addPoint(
                                name: name,
                                price: price,
                                information: information,
                                lat: lat,
                                lon: lon,
                                associate: associate
                            )
                            selection = "A" // Optional navigation or pop action
                        } catch {
                            print("DEBUG: Failed to add location: \(error.localizedDescription)")
                        }
                    }
                }
                .navigationTitle("Add New Location")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    //    private func addLocation() {
    //        let newLocation = Location(name: name, price: price, information: information, lat: lat, lang: long,associate: associate)
    //        context.insert(newLocation)
    //        try? context.save()
    //        presentationMode.wrappedValue.dismiss()
    //    }
}

//struct AddLocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddLocationView()
//    }
//}
