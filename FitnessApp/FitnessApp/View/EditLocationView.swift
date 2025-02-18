//
//  EditLocationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 24/4/24.
//

import SwiftUI

struct EditLocationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var location: MapPoint

    @State private var name: String
    @State private var price: Double
    @State private var information: String
    @State private var lat: Double
    @State private var lon: Double
    @State private var associate: Int

    let associates = ["Yava", "Fitness Club", "International Club"]

    // THEME
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData

    init(location: MapPoint) {
        self.location = location
        _name = State(initialValue: location.name)
        _price = State(initialValue: location.price)
        _information = State(initialValue: location.information)
        _lat = State(initialValue: location.lat)
        _lon = State(initialValue: location.lon)
        _associate = State(initialValue: location.associate)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)

                Picker("Associate", selection: $associate) {
                    Text("Yava").tag(1)
                    Text("Fitness Club").tag(2)
                    Text("International Club").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Price", value: $price, format: .number)
                    .keyboardType(.decimalPad)

                TextField("Information", text: $information)

                TextField("Latitude", value: $lat, format: .number)
                    .keyboardType(.decimalPad)

                TextField("Longitude", value: $lon, format: .number)
                    .keyboardType(.decimalPad)

                Button(action: {
                    Task {
                        let updatedLocation = MapPoint(
                            id: location.id,
                            name: name,
                            price: price,
                            information: information,
                            lat: lat,
                            lon: lon,
                            associate: associate
                        )

                        do {
                            try await viewModel.updateLocation(updatedLocation)
                            await viewModel.fetchLocations() // Optional refresh after update
                            dismiss()
                        } catch {
                            print("Failed to update location: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Update")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themes[theme.themeSettings].themeColor)
                        .cornerRadius(9)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("Edit Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
