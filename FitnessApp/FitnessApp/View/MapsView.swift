//
//  NewPointAdditionView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 22/4/24.
//

import SwiftUI
import MapKit
import Foundation

// Define the Stadium struct in a shared scope, outside of any class
struct Stadium: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// Define the StadiumSearchService class
class StadiumSearchService {
    func searchStadiums(completion: @escaping ([Stadium]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Stadium in Patra, Greece"
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let stadiums = response.mapItems.compactMap { item -> Stadium? in
                guard let name = item.name else { return nil }
                return Stadium(name: name, coordinate: item.placemark.coordinate)
            }
            
            DispatchQueue.main.async {
                completion(stadiums)
            }
        }
    }
}


struct MapsView: View {
    @State private var stadiums: [Stadium] = []
    @State private var mapRect: MKMapRect = MKMapRect.world
    @State private var selectedStadium: Stadium?

    var body: some View {
        Map(mapRect: $mapRect, annotationItems: stadiums) { stadium in
            MapAnnotation(coordinate: stadium.coordinate) {
                Button(action: {
                    self.selectedStadium = stadium
                }) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .background(Circle().fill(Color.white).frame(width: 30, height: 30))
                }
                .popover(isPresented: Binding<Bool>(get: {
                    self.selectedStadium?.id == stadium.id
                }, set: { _ in })) {
                    if let selectedStadium = selectedStadium {
                        Text(selectedStadium.name)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            StadiumSearchService().searchStadiums { stadiums in
                self.stadiums = stadiums
                self.mapRect = self.computeMapRect(for: stadiums)
            }
        }
    }

    // Function to compute an MKMapRect that encompasses all stadiums
    private func computeMapRect(for stadiums: [Stadium]) -> MKMapRect {
        let points = stadiums.map { MKMapPoint($0.coordinate) }
        let rects = points.map { MKMapRect(origin: $0, size: MKMapSize()) }
        let fittingRect = rects.reduce(MKMapRect.null) { $0.union($1) }
        return fittingRect
    }
}


struct MapsView_Previews: PreviewProvider {
    static var previews: some View {
        MapsView()
    }
}
