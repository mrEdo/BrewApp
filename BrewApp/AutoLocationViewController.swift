//
//  AutoLocationViewController.swift
//  BrewApp
//
//  Created by admin on 7/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Results: Decodable {
    let totalResults:Int
    let data:[Brewery]
}
struct Brewery: Decodable {
    let name: String
    let locality: String
    let region: String
    let latitude: Double
    let longitude: Double
    let isPrimary: String
    let inPlanning: String
    let isClosed: String
    let openToPublic: String
    let locationType: String
    let locationTypeDisplay: String
}


class AutoLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countLabel: UILabel!
    
    
    var lat:Double = 0
    var lon:Double = 0

    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // Do any additional setup after loading the view.
    }
    func setupLocationManager() {
        //locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager .locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting user know they have to turn this on.
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know whats up
            break
        case .authorizedAlways:
            break
        }
    }
    public func addBreweryAnnotations() {
        let apiString = "https://www.brewerydb.com/browse/map/get-breweries?lat=\(lat)&lng=\(lon)&radius=25"
        
        guard let url = URL(string:apiString) else
        { return }
        
        URLSession.shared.dataTask(with: url){(data, response, err) in
            
            guard let breweryData = data else {return}
            
            do {
                let bData = try JSONDecoder().decode(Results.self, from: breweryData)
                
                
                print(bData.data)
                
                //                self.nominees = pData.results
                DispatchQueue.main.async {
                    for brewSpot in bData.data {
                        let brewAnnotation = MKPointAnnotation()
                        brewAnnotation.title = brewSpot.name
                        brewAnnotation.coordinate = CLLocationCoordinate2D(latitude: brewSpot.latitude, longitude: brewSpot.longitude)
                        self.mapView.addAnnotation(brewAnnotation)
                        print(brewSpot.name)
                    }
                    self.countLabel.text = bData.totalResults == 1 ? "You have \(String(bData.totalResults)) brewery" : "You have \(String(bData.totalResults)) breweries"
                }
                
                
                //print(pData)
            } catch let jsonErr {
                print("You've got the following jsonError \(jsonErr)")
            }
            
            }.resume()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AutoLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let center = CLLocationCoordinate2D(latitude: svlat, longitude: svlon)
        
        lat = center.latitude
        lon = center.longitude
        
        //lat = svlat
        //lon = svlon
        
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated:true)
        
        addBreweryAnnotations()
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
