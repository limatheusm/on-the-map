//
//  AddLocationViewController.swift
//  on the map
//
//  Created by Matheus Lima on 08/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var errorStringLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Properties
    var httpMethodToSubmit: String = ""
    var latitude: Double? = nil
    var longitude: Double? = nil
    var studentLocation: StudentLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorStringLabel.text = ""
        setSubmitEnable(false)
    }
    
    // MARK: Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        if !self.mapView.annotations.isEmpty { self.mapView.removeAnnotations(self.mapView.annotations) }
        
        guard let location = locationTextField.text, !location.isEmpty else {
            displayError("location field is required")
            return
        }
        guard let website = websiteTextField.text, !website.isEmpty else {
            displayError("website field is required")
            return
        }
        LoaderView.show()
        self.searchLocation(location) { (results) in
            DispatchQueue.main.async {
                LoaderView.hide()
                if let results = results, !results.isEmpty {
                    let mapItem = results[0]
                    self.pinPreviewLocation(mapItem: mapItem)
                    
                    /* Set lat/long */
                    self.latitude = mapItem.placemark.coordinate.latitude
                    self.longitude = mapItem.placemark.coordinate.longitude
                    
                    self.setSubmitEnable(true)
                } else {
                    self.displayError("No location found")
                }
            }
        }

    }
    
    @IBAction func submitPressed(_ sender: Any) {
        setUIEnable(false)
        LoaderView.show()
        ParseClient.sharedInstance().addStudentLocation(httpMethod: self.httpMethodToSubmit, mapString: locationTextField.text!, mediaURL: websiteTextField.text!, latitude: self.latitude!, longitude: self.longitude!) { (success, errorString) in
            
            DispatchQueue.main.async {
                self.setUIEnable(true)
                LoaderView.hide()
                if success {
                    self.showToast(controller: self, message : "Success!", seconds: 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.displayError(errorString ?? "Submit failed")
                }
            }
            
            
        }
    }
}

// MARK: Map functions

extension AddLocationViewController {
    
    // MARK: Search and recovery lat/lon from location
    func searchLocation(_ location: String, completion: @escaping (_ results: [MKMapItem]?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        request.region = self.mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                completion(nil)
                return
            }
            completion(response.mapItems)
        }
    }
    
    // MARK: pin preview location on map
    func pinPreviewLocation(mapItem: MKMapItem) {
        
        /* Create the annotation and set its coordiate, title, and subtitle properties */
        let udacityClient = UdacityClient.sharedInstance()
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = "\(udacityClient.firstName ?? "") \(udacityClient.lastName ?? "")"
        annotation.subtitle = websiteTextField.text!
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

// MARK: Helpers

extension AddLocationViewController {
    func setUIEnable(_ enabled: Bool) {
        errorStringLabel.text = ""
        findLocationButton.isEnabled = enabled
        findLocationButton.alpha = enabled ? 1 : 0.5
        submitButton.isEnabled = enabled
        submitButton.alpha = enabled ? 1 : 0.5
    }
    
    func setSubmitEnable(_ enabled: Bool) {
        errorStringLabel.text = ""
        submitButton.isEnabled = enabled
        submitButton.alpha = enabled ? 1 : 0
        mapView.alpha = enabled ? 1 : 0
    }
    
    func displayError(_ errorString: String?) {
        guard let errorString = errorString else { return }
        print(errorString)
        errorStringLabel.text = errorString
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double = 2.0, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            completion()
        }
    }
}
