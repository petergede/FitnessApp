//
//  AddLocationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 23/4/24.
//

//import SwiftUI
//
import SwiftUI
import CoreData
//
struct AddLocationView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var selection: String? = nil
    
    @State private var name: String = ""
    @State private var price: Double = 0.0
    @State private var information: String = ""
    @State private var lat: Double = 0.0
    @State private var long: Double = 0.0
    @State private var associate: Int = 0
    
    var location: Location? // Optional to handle new or existing locations

       init(location: Location?) {
           self.location = location
           if let location = location {
               _name = State(initialValue: location.name)
               _price = State(initialValue: location.price)
               _information = State(initialValue: location.information)
               _lat = State(initialValue: location.lat)
               _long = State(initialValue: location.lang)
               _associate = State(initialValue: location.associate)
           }
       }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", value: $price, formatter: NumberFormatter())
                TextField("Information", text: $information)
                TextField("Latitude", value: $lat, formatter: NumberFormatter())
                TextField("Longitude", value: $long, formatter: NumberFormatter())
                Section("Associate"){
                    Picker("Associate",selection: $associate) {
                        Text("Yava").tag(1)
                        Text("Fintess Club").tag(2)
                        Text("Interntional Club").tag(3)
                    }
                    .pickerStyle(.segmented)
                }
                Button("Add Location") {
                    addLocation()
                    selection = "A"
                    }
                .background(
                    NavigationLink(destination: LocationListView(), tag: "A", selection: $selection) { EmptyView() }.hidden()
                    )
                Button("View Locations") {
                    selection = "B"
                    }
                .background(
                    NavigationLink(destination: LocationListView(), tag: "B", selection: $selection) { EmptyView() }.hidden()
                    )
            }
            .navigationTitle("Add New Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addLocation() {
        let newLocation = Location(name: name, price: price, information: information, lat: lat, lang: long,associate: associate)
        context.insert(newLocation)
        try? context.save()
        presentationMode.wrappedValue.dismiss()
    }
}

//struct AddLocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddLocationView()
//    }
//}
