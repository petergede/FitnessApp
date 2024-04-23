//
//  MapViewController.swift
//  FitnessApp
//
//  Created by Petros Gedekakis on 8/4/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: self.view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        searchStadiumsAndArenas()
    }
    
    func searchStadiumsAndArenas() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "stadium"
        // Define a region where to search, here it's set around the current user location
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                if let location = item.placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}
