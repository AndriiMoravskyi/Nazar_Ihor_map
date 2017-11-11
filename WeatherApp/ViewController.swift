//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nazar Kuradovetson on 2/15/17.
//  Copyright © 2017 Nazar Kuradovetson. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class ViewController: UIViewController {
    
    // MARK: - Parameters
    let locationManager = CLLocationManager()
    let menuTransition = MenuViewAnimator()
    var currentOverlay = MKTileOverlay()
    var mapOverlay = MKTileOverlay()
    var tapAnnotation : WeatherCustomAnnotation? = nil
    var tapCoordinates = CLLocationCoordinate2D()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Solar Map"
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        centerMap(latitude: kInitialMapLatitude, longitude: kInitialMapLongitude)
        mapView.delegate = self
        addBoundry()
        
        }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "menuSegueIdentifier" {
            if let menuController = segue.destination as? MenuTableViewController {
                menuController.modalPresentationStyle = .custom
                menuController.transitioningDelegate = menuTransition
            }
        }
    }
    

    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        setOverlay(option: sourceController.selectedOption)
    }
    
    // MARK: - Extra functions
    /**
     Centers map with input latitude and longitude
     - parameter latitude: maps center latitude
     - parameter longitude: maps center longitude
    */
    func centerMap(latitude : Double, longitude: Double) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, kMapScale, kMapScale)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
     Adds tile with appropriate url template
     - parameter urlTemplate: valid string url template for map tiles, if nil removes all tiles
     */
    func addMapTile(urlTemplate: String?) {
        guard let urlTemplate = urlTemplate else {
            mapView.remove(currentOverlay)
            currentOverlay = MKTileOverlay()
            return
        }
        if currentOverlay.urlTemplate != urlTemplate {
            mapView.remove(currentOverlay)
            currentOverlay = MKTileOverlay(urlTemplate: urlTemplate)
            mapView.add(currentOverlay)
            infoView.isHidden = true
        }
    }
    
    /**
     Adds maps tile with appropriate url template that replace current map
     - parameter urlTemplate: valid string url template for map tiles, if nil sets default map
     */
    func replaceMap(urlTemplate: String?) {
        guard let urlTemplate = urlTemplate else {
            mapView.remove(mapOverlay)
            mapOverlay = MKTileOverlay()
            return
        }
        if mapOverlay.urlTemplate != urlTemplate {
            mapView.remove(mapOverlay)
            mapOverlay = MKTileOverlay(urlTemplate: urlTemplate)
            mapOverlay.canReplaceMapContent = true
            mapView.insert(mapOverlay, at: 0)
        }
    }
    
    /**
     Sets maps overlay with option
     - parameter option: map overlay option 
     */
    func setOverlay(option : MapsOptions) {
        switch option {
        case .NoneTile:
            addMapTile(urlTemplate: nil)
        case .TemperatureTile:
            addMapTile(urlTemplate: kTemperatureUrlTemplate)
            infoView.isHidden = false
        case .WindSpeedTile:
            addMapTile(urlTemplate: kWindSpeedUrlTemplate)
        case .PrecipitationTile:
            addMapTile(urlTemplate: kPrecipitationUrlTemplate)
        case .PressureTile:
            addMapTile(urlTemplate: kPressureUrlTemplate)
        case .OpenStreetMap:
            replaceMap(urlTemplate: kOpenStreetUrlTemplate)
        case .GoogleMap:
            replaceMap(urlTemplate: kGoogleMapUrlTemplate)
        case .DefaultMap:
            replaceMap(urlTemplate: nil)
        default:
            break
        }
    }
    
    func addBoundry()
    {
        var points=[CLLocationCoordinate2DMake(49.913104, 23.461022),CLLocationCoordinate2DMake(49.916990, 23.477445),CLLocationCoordinate2DMake(49.909916, 23.481738), CLLocationCoordinate2DMake(49.908124, 23.463992)]
    
        
       let polygon = MKPolygon(coordinates: &points, count: points.count)
        
        mapView.add(polygon)
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            let render = MKTileOverlayRenderer(tileOverlay: overlay)
            return render
        } else if let overlay = overlay as? MKPolygon {
            let render = MKPolygonRenderer(polygon: overlay)
            render.strokeColor = UIColor.red
            render.lineWidth = 5
            return render
        }
        return MKOverlayRenderer()
    }    
}
