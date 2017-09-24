//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/15/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class ViewController: UIViewController {
    
    // MARK: - Parameters
    let locationManager = CLLocationManager()
    let transition = DetailViewAnimator()
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        centerMap(latitude: kInitialMapLatitude, longitude: kInitialMapLongitude)
        mapView.delegate = self
        
        }
    
    @IBAction func relief(_ sender: UIButton){
   
            mapView.remove(mapOverlay)
            mapOverlay.canReplaceMapContent = true
            mapView.mapType = MKMapType.satellite

    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegueIdentifier" {
            if let detailController = segue.destination as? DetailViewController {
                detailController.transitioningDelegate = self
                detailController.modalPresentationStyle = .overCurrentContext
                detailController.pointCoordinates = tapCoordinates
            }
        } else if segue.identifier == "menuSegueIdentifier" {
            if let menuController = segue.destination as? MenuTableViewController {
                menuController.modalPresentationStyle = .custom
                menuController.transitioningDelegate = menuTransition
            }
        }
    }
    
    // MARK: - IBActions
    /// User tap handler
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        tapCoordinates = mapView.convert(location, toCoordinateFrom: mapView)
    
        centerMap(latitude: tapCoordinates.latitude + 3, longitude: tapCoordinates.longitude)
        
        if let tapAnnotation  = self.tapAnnotation {
            mapView.removeAnnotation(tapAnnotation)
        }
        
        tapAnnotation = WeatherCustomAnnotation(coordinate: tapCoordinates)
        mapView.addAnnotation(tapAnnotation!)
        
        performSegue(withIdentifier: "detailsSegueIdentifier", sender: nil)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? WeatherCustomAnnotation {
            let identifier = "touchPin"
            var view : MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                UIGraphicsBeginImageContext(CGSize(width: 20, height: 20))
                #imageLiteral(resourceName: "circle").draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                let circleImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                view.image = circleImage
                view.canShowCallout = false
            }
            return view
        }
        return nil
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentCoordinate = locations[0].coordinate
        tapCoordinates = CLLocationCoordinate2D(latitude: currentCoordinate.latitude,
                                                longitude: currentCoordinate.longitude)
        self.locationManager.stopUpdatingLocation()
        if let tapAnnotation  = self.tapAnnotation {
            mapView.removeAnnotation(tapAnnotation)
        }
        
        tapAnnotation = WeatherCustomAnnotation(coordinate: tapCoordinates)
        mapView.addAnnotation(tapAnnotation!)
        centerMap(latitude: tapCoordinates.latitude + 3, longitude: tapCoordinates.longitude)
        performSegue(withIdentifier: "detailsSegueIdentifier", sender: nil)
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
