//
//  MapViewController.swift
//  PlannerApp
//
//  Created by aadeeb rashid on 4/22/22.
//

import UIKit
import CoreLocation
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longText: UITextField!
    @IBOutlet weak var latText: UITextField!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(locationManager.authorizationStatus == .authorizedWhenInUse ||
        locationManager.authorizationStatus == .authorizedAlways) {
            currentLoc = locationManager.location
            print(locationManager.location.debugDescription)
            let lat = currentLoc.coordinate.latitude
            let long = currentLoc.coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
       
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        longText.text = view.annotation?.coordinate.longitude.description
        latText.text = view.annotation?.coordinate.latitude.description
    }
    @IBAction func search(_ sender: Any) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
                request.region = mapView.region
                let search = MKLocalSearch(request: request)
                
                search.start { response, _ in
                    guard let response = response else {
                        return
                    }
                    print( response.mapItems )
                    var matchingItems:[MKMapItem] = []
                    matchingItems = response.mapItems
                    for i in 1...matchingItems.count - 1
                    {
                            let place = matchingItems[i].placemark
                        let ani = MKPointAnnotation()
                        ani.coordinate = place.location!.coordinate
                        ani.title = place.name
                        ani.subtitle = place.subLocality
                        
                        self.mapView.addAnnotation(ani)
                        
                    }
                 }
    }
    
    @IBAction func submitAttempt(_ sender: UIButton) {
        if(longText.text != nil && latText.text != nil)
        {
            performSegue(withIdentifier: "mapUnwind", sender: self)
        }
        else
        {
            let alertController = UIAlertController(title: nil, message: "Please provide longitude and latitude", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapUnwind")
        {
            let dest = segue.destination as? AddTaskViewController
            dest?.lat = Float(latText.text!)
            dest?.long = Float(longText.text!)
        }
    }
}
