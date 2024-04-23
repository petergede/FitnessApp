//
//  LocationView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 23/4/24.
//

import SwiftUI

struct LocationView: View {
    var body: some View {
            let location = Location(name: "Example Place", price: 100.0, information: "Detailed description", lat: "38.2466", lang: "21.7346")
            MapView(location: location)
        }
}

#Preview {
    LocationView()
}
