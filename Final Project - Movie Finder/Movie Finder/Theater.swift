//
//  Theater.swift
//  Movie Finder
//
//  Created by Louise Chan on 2019-07-30.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Theater {
//    var name: String
//    var address: String
    var url: String
    var marker: MKPointAnnotation
    //var coords: CLLocationCoordinate2D
    
    init (name: String, urlSlug: String, address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        self.name = name
//        self.address = address
        self.url = "https://www.cineplex.com/Theatre/" + urlSlug
        
        marker = MKPointAnnotation()
        let coords = CLLocation(latitude: latitude, longitude: longitude)
        marker.title = name
        marker.subtitle = address
        marker.coordinate = coords.coordinate
        
//        self.coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
