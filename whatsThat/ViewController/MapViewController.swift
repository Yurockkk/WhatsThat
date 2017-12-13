//
//  MapViewController.swift
//  whatsThat
//
//  Created by Yubo on 12/12/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class MapViewController: UIViewController {
    
    var favorites:[Favorite]!
    let locationFinder = LocationFinder()
    var currentLon: Double?
    var currentLat: Double?

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController, viewDidLoad")
        mapView.delegate = self
        locationFinder.delegate = self
        
        self.favorites = PersistanceManager.sharedInstancec.fetchFavorites()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        locationFinder.findLocation()

    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MapViewController, view will appear")
        self.favorites = PersistanceManager.sharedInstancec.fetchFavorites()
        DispatchQueue.main.async{
        self.mapView.removeAnnotations(self.mapView.annotations)
            self.showFavPinsOnMap()
            self.mapView.reloadInputViews()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIdentificationFromMap" {
            print("in prepare")
            let destVC = segue.destination as? PhotoDetailsViewController
            let location = sender as! FavoritePin
            destVC?.selectedTitle = location.title
            
        }
    }
 
    func showFavPinsOnMap(){
        favorites.forEach { (fav) in
            if let lon = fav.lon, let lat = fav.lat{
                let favPin = FavoritePin(title: fav.title, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                mapView.addAnnotation(favPin)
            }
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? FavoritePin else { return nil }
        // 3
        let identifier = "marker"
        var view: MKPinAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! FavoritePin
//        print("location: \(location.title)")
        self.performSegue(withIdentifier: "showIdentificationFromMap", sender: location)
    }
    
}

extension MapViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
        print("we get location data, lon: \(longitude), lat: \(latitude)")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        showFavPinsOnMap()
        
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        print("we didn't get location data")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        //set initialLocation to GWU if we can't get location data
        let initialLocation = CLLocation(latitude: 38.902041367854324, longitude: -77.053815204948066)
        centerMapOnLocation(location: initialLocation)
        showFavPinsOnMap()
        
    }
}
