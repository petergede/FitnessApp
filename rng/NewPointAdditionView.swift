//
//  NewPointAdditionView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 22/4/24.
//

import SwiftUI
import MapKit
import Foundation

struct PointOfInterest {
    var name: String
    var price: String
    var description: String
    var coordinate: CLLocationCoordinate2D?
}

struct NewPointAdditionView: View {
    @State private var pointOfInterest = PointOfInterest(name: "", price: "", description: "")
    @State private var showingMap = false
    // Set the initial region to Patra, Greece
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.2466, longitude: 21.7346), latitudinalMeters: 5000, longitudinalMeters: 5000)

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $pointOfInterest.name)
                TextField("Price", text: $pointOfInterest.price)
                TextField("Description", text: $pointOfInterest.description)
                
                Button("Add Location") {
                    showingMap = true
                }
            }
            .navigationBarTitle("Add New Point")
            .sheet(isPresented: $showingMap) {
                MapsView(region: $region, onSelectLocation: { coordinate in
                    pointOfInterest.coordinate = coordinate
                    showingMap = false
                })
            }
        }
    }
}


struct MapsView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var onSelectLocation: (CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Set the initial region and add a draggable annotation
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = region.center
        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Check and update the annotation's position if it is not the same as the region center
        if let currentAnnotation = uiView.annotations.first as? MKPointAnnotation {
            currentAnnotation.coordinate = region.center
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapsView

        init(_ parent: MapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "draggable"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.isDraggable = true
            }
            return view
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            if newState == .ending {
                let draggedLocation = view.annotation!.coordinate
                parent.onSelectLocation(draggedLocation)
                // Update the region to keep the map centered on the new annotation position
                mapView.setRegion(MKCoordinateRegion(center: draggedLocation, latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)
            }
        }
    }
}


struct NewPointAdditionView_Previews: PreviewProvider {
    static var previews: some View {
        NewPointAdditionView()
    }
}
