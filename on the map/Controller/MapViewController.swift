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
//
//        /* GET the location points */
//        self.fetchAndPopulatePoints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /* GET the location points */
        self.fetchAndPopulatePoints()
    }
    
    func fetchAndPopulatePoints() {
        /* Clear annotations */
        if !self.mapView.annotations.isEmpty { self.mapView.removeAnnotations(self.mapView.annotations) }
        
        /* Fetch locations */
        ParseClient.sharedInstance().getStudentsLocation { (studentsLocation, errorString) in
            guard (errorString == nil) else {
                print(errorString!)
                return
            }
            
            guard let studentsLocation = studentsLocation else {
                print("Students Location null")
                return
            }
            
            DispatchQueue.main.async {
                self.populateMap(locations: studentsLocation)
            }
        }
    }
    
    func populateMap(locations: [StudentLocation]) {
        
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

// MARK: Helpers

extension MapViewController {
    
    // MARK: - Sample Data
    
    // Some sample data. This is a dictionary that is more or less similar to the
    // JSON data that you will download from Parse.
    
    func hardCodedLocationData() -> [[String : Any]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }
}
