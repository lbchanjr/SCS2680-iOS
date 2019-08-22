//
//  ViewController.swift
//  Movie Finder
//
//  Created by Louise Chan on 2019-07-30.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var mapLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var theaters: Array<Theater>!
    var displayLocFlag: Bool = false
    let regionInMeters: Double = 50000
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
    }
    
    @IBAction func findLocationButtonClick(_ sender: Any) {
        // Check if Location services is enabled and app is authorized to use it.
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Start looking for the user's current location.
            displayLocFlag = true
            activateLocationServices()
            mapLabel.text = "Searching nearby theaters..."
            detailsButton.isEnabled = false
            
        } else {
            // Prompt user for permission to use Location services
            stopAndHideActivityIndicator()
            locationManager.requestWhenInUseAuthorization()
            displayLocFlag = true
        }
        
    }
    
    // Allows the map to center in on the current user location.
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Place pin markers on the map after all the theater markers have been setup.
    func setTheaterMarkers(theaters: Array<Theater>){
        
        if theaters.count == 0 {
            stopAndHideActivityIndicator()
            mapLabel.text = "No theaters found."
            return
        }
        
        for theater in theaters {
            mapView.addAnnotation(theater.marker)
        }
        
        stopAndHideActivityIndicator()
        detailsButton.isEnabled = true
        mapLabel.text = "Found \(theaters.count) theaters close to your location."
        
    }
    
    // Create map item that will be used to display the custom map annotation.
    private func mapItem(marker: MKPointAnnotation) -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: marker.subtitle]
        let placemark = MKPlacemark(coordinate: marker.coordinate, addressDictionary: addressDict as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = marker.title
        return mapItem
    }
    
    // Enable Location services and request for current user coordinates (once only)
    private func activateLocationServices() {
        centerViewOnUserLocation();
        locationManager.requestLocation()
        
        // Show and animate the activity indicator object
        searchIndicator.isHidden = false
        searchIndicator.startAnimating()
    }

    // Hides the activity indicator and stops it.
    private func stopAndHideActivityIndicator() {
        // Stop and hide the activity indicator object
        searchIndicator.stopAnimating()
        searchIndicator.isHidden = true
    }
    
    // Obtain list of movie theaters in JSON format and arrange it in format that will
    // be displayed on the screen.
    private func getTheaterList() {
        let session = URLSession.shared
        let theaterURL = URL(string: "https://www.cineplex.com/api/v1/theatres?language=en-us");
        
        let task = session.dataTask(with: theaterURL!) {
            (data, response, error) in
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let theaterData = JSON(data: data)
                
                // Reformat JSON theater data into the Theater class and add it to an array of Theater class
                self.theaters = Array<Theater>()
                let theaterArray = theaterData["data"].arrayValue
                
                for theaterjson in theaterArray {
                    let distance = theaterjson["distance"].doubleValue * 2
                    if distance < self.regionInMeters {
                        
                        let address = theaterjson["address1"].stringValue + ", " + theaterjson["city"].stringValue + ", " + theaterjson["provinceCode"].stringValue + " " + theaterjson["postalCode"].stringValue
                        
                        self.theaters.append(Theater(name: theaterjson["name"].stringValue, urlSlug: theaterjson["urlSlug"].stringValue, address: address, latitude: theaterjson["latitude"].doubleValue, longitude: theaterjson["longitude"].doubleValue))
                    }
                }
                
                DispatchQueue.main.async {
                    // Process any UI-related updates after page has been read.
                    if let error = error {
                        self.stopAndHideActivityIndicator()
                        self.mapLabel.text = "Search error. Try again."
                        print(error)
                    }
                    else {
                        self.setTheaterMarkers(theaters: self.theaters)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    // Call when Location service authorization setting has changed.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
        else {
            stopAndHideActivityIndicator();
            // Prompt user for permission to use Location services
            locationManager.requestWhenInUseAuthorization()
            displayLocFlag = true
        }
        
        
    }
    
    // Called when coordinates were updated by location services
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if displayLocFlag == true {
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
            
            getTheaterList()
        }
        else {
            stopAndHideActivityIndicator()
            mapLabel.text = "Click on 'Find Theatres' to begin."
        }
        print("Your Coordinate: \(String(describing: locations.last?.coordinate))")
    }
    
    // Just print error in console for geolocation failure.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: MKMapViewDelegate methods
    // Create custom annotation for the map markers
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else { return nil }
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    // Called when the annotation text is tapped. This code will open Maps app and input the address of marker.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MKPointAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        self.mapItem(marker: location).openInMaps(launchOptions: launchOptions)
    }
    
    // MARK: Navigation methods
    // Prepare for transition to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TheaterTableViewController {
            vc.setTheaters(theaters: theaters)
        }
    }

}


