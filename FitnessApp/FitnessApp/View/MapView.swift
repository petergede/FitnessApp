//
//  MapView.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 28/4/24.
//

import SwiftUI
import MapKit
import CoreData

class LocationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let locationName: String
    let associate: String
    let price: Double
    
    init(title: String, locationName: String, associate: String, price: Double, latitude: Float, longitude: Float) {
        self.title = title
        self.locationName = locationName
        self.associate = associate
        self.price = price
        self.coordinate = CLLocationCoordinate2D(
            latitude: Double(latitude),
            longitude: Double(longitude)
        )
        super.init()
    }
    
    var subtitle: String? {
        return "\(locationName) - Price: \(String(format: "%.2f", price))"  // Formatting price as a string
    }
}

//Fetch user's location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}


//Create markers depending on associate
class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let locationAnnotation = annotation as? LocationAnnotation else {
            return nil  // Skip non-custom annotations
        }
        

        let identifier = "location"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        // Dynamically set the color based on selection state
        if mapView.selectedAnnotations.contains(where: { $0 as? LocationAnnotation === locationAnnotation }) {
            view.markerTintColor = .orange
        } else {
            view.markerTintColor = getColor(for: locationAnnotation.associate)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationView = view as? MKMarkerAnnotationView {
            annotationView.markerTintColor = .orange  // This should change the color to orange
            print("Marker color changed to orange")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotationView = view as? MKMarkerAnnotationView, let locationAnnotation = view.annotation as? LocationAnnotation {
            annotationView.markerTintColor = getColor(for: locationAnnotation.associate)  // Revert color based on the associate
        }
    }
    
    
    private func getColor(for associate: String) -> UIColor {
        switch associate {
        case "Yava":
            return .red
        case "Fitness Club":
            return .blue
        case "International Club":
            return .green
        default:
            return .gray  // Default color if none of the cases match
        }
    }
}

//View that fetch the data and displays the map
struct LocationsMap: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: TrainingLocation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingLocation.name, ascending: true)]
    ) var locations: FetchedResults<TrainingLocation>
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.246640, longitude: 21.734574),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        MapView(
            annotations: locations.map { location in
                LocationAnnotation(
                    title: location.name ?? "Unknown Location",
                    locationName: location.name ?? "No description",
                    associate: location.associate ?? "None",
                    price: location.price,
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            },
            region: $region
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let userLocation = locationManager.location?.coordinate {
                region = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
    }
}




//Go Back
struct LocationsMapContainerView: View {
    var body: some View {
        NavigationView {
            LocationsMap()
                .navigationBarTitle("Map", displayMode: .inline)
                .navigationBarItems(leading: NavigationLink("Back", destination: FitnessView()))
        }
    }
}

//The map
struct MapView: UIViewRepresentable {
    var annotations: [LocationAnnotation]
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(LocationAnnotation.self))
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let currentAnnotations = Set(uiView.annotations.compactMap { $0 as? LocationAnnotation })
        let newAnnotations = Set(annotations)
        
        let annotationsToRemove = currentAnnotations.subtracting(newAnnotations)
        let annotationsToAdd = newAnnotations.subtracting(currentAnnotations)
        
        uiView.removeAnnotations(Array(annotationsToRemove))
        uiView.addAnnotations(Array(annotationsToAdd))
        
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}




