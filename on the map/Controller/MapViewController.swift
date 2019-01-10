//
//  MapViewController.swift
//  on the map
//
//  Created by Matheus Lima on 06/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    func refresh() {
        self.populateMap()
    }
    
    func populateMap() {
        /* Clear annotations */
        if !self.mapView.annotations.isEmpty { self.mapView.removeAnnotations(self.mapView.annotations) }
        
        /* Students Location */
        guard let locations = StudentsDataSource.studentsLocation else { return }
        
        /* Create MKPointAnnotation */
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            guard let latitude = location.latitude, let longitude = location.longitude else {
                continue
            }
            
            /* Get student info */
            guard let first = location.firstName, let last = location.lastName, let mediaURL = location.mediaURL else {
                continue
            }
            
            /* Create coordinate */
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            /* Create the annotation and set its coordiate, title, and subtitle properties */
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            /* Place the annotation in an array of annotations */
            annotations.append(annotation)
        }
        
        /* Add the annotations to the map */
        self.mapView.addAnnotations(annotations)
    }
    
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    /* Creating a view for annotation */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    /* Handle tap to open mediaURL */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!)
            }
        }
    }
}
