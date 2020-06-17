//
//  MapViewController.swift
//  favouriteplacestovisit_Amandeep_344
//
//  Created by user174568 on 17/06/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit
import MapKit

// protocol used for sending data back
protocol DataEnteredDelegate2 {
    func userDidEnterInformation(name:String,subtitle:String,lat : Double,long:Double)
}


class MapViewController: UIViewController,UIGestureRecognizerDelegate{
    
    @IBOutlet var mapView: MKMapView?
    var delegate: DataEnteredDelegate2?
    let locationManager = CLLocationManager()
    var selectedPinView: MKAnnotation!
    let places = Place.getPlaces()
    
    var titleName = ""
    var backButton : UIBarButtonItem!
    
    var lat  = 0.0
    var long = 0.0
    
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        mapView!.addGestureRecognizer(gestureRecognizer)
        setPinOnMap()
    }
    

    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView!.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView!.addAnnotation(annotation)
        setNewPlaces(lat1: coordinate.latitude, long1: coordinate.longitude)
        
    }
    
    func setNewPlaces(lat1: Double,long1: Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat1 , longitude: long1)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.name  {
                print(locationName)
            }
            
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
            self.delegate?.userDidEnterInformation(name:  placeMark.name ?? "", subtitle: placeMark.country ?? "", lat: lat1, long: long1)
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Access the last object from locations to get perfect current location
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.00775, longitudeDelta: 0.00775)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            print(myLocation)
            let region = MKCoordinateRegion(center: myLocation, span: span)
            mapView!.setRegion(region, animated: true)
        }
        self.mapView!.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    
    func setPinOnMap() {
        
        var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
        let annotation = MKPointAnnotation()
        
        locValue.latitude = lat
        locValue.longitude = long
        
        annotation.coordinate = locValue
        mapView!.isZoomEnabled = false
        
        self.mapView!.showAnnotations(self.mapView!.annotations, animated: true)
        mapView?.addAnnotation(annotation)
        
    }
}
