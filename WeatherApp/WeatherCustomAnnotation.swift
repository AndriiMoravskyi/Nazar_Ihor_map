//
//  WeatherCustomAnnotation.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/21/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit
import MapKit

class WeatherCustomAnnotation: NSObject,  MKAnnotation {
    
    // MARK: - Parameters
    var coordinate: CLLocationCoordinate2D
    
    // MARK: - Life cycle
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
