//
//  Interfaces.swift
//  SolarMap
//
//  Created by Nazar Kuradovets on 2/18/17.
//  Copyright © 2017 Nazar Kuradovets. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Constants
let kTemperatureUrlTemplate = "http://maps.owm.io:8099/5735d67f5836286b007625cd/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc"
let kPrecipitationUrlTemplate = "http://f.maps.owm.io:8099/57456d1237fb4e01009cbb17/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc"
let kWindSpeedUrlTemplate = "http://a.maps.owm.io:8099/5735d67f5836286b0076267b/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc"
let kPressureUrlTemplate = "http://a.maps.owm.io:8099/5837ee50f77ebe01008ef68d/{z}/{x}/{y}?hash=ba22ef4840c7fcb08a7a7b92bf80d1fc"
let kOpenStreetUrlTemplate = "http://mt.google.com/vt/lyrs=m&p&x={x}&y={y}&z={z}"
let kGoogleMapUrlTemplate = "http://mt.google.com/vt/lyrs=t&x={x}&y={y}&z={z}"
let kMapScale : Double = 100000
let kInitialMapLatitude =  49.8293460
let kInitialMapLongitude = 24.0222010

// MARK: - Enums
enum MapsOptions: String {
    case DefaultMap = "Default"
    case GoogleMap = "Google terrain map"
    case OpenStreetMap = "Terrain map"
    case NoneTile = "None"
    case TemperatureTile = "Temperature"
    case WindSpeedTile = "Wind speed"
    case PrecipitationTile = "Precipitation"
    case PressureTile = "Pressure"
    case CitiesAnnotations = "Cities Annotations"
    static let allValues = [ DefaultMap, GoogleMap, OpenStreetMap, TemperatureTile, WindSpeedTile, PrecipitationTile, PressureTile, CitiesAnnotations]
}

// MARK: - Protocols
protocol WeatherParserInterface {
    
    /**
      Parse data with weather conditions
      - Parameter data: response data from weather server
     */
    func getWeatherConditionsFor(data : Data) -> WeatherCondition
}

protocol WeatherDataInterface {
    
    /**
     Gets current weather for position
     - Parameter latitude: latitude for position
     - Parameter longitude: longitude for position
     - Parameter completionHandler: completion for getting current weather conditions
     */
    func getCurrentWeatherFor(latitude: Double,
                              longitude: Double,
                              completionHandler: @escaping (_ conditions: WeatherCondition) -> Void )
}
