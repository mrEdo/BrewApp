//
//  SearchViewController.swift
//  BrewApp
//
//  Created by admin on 7/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    var countLabelText:String = "Original Text"
    var addressInput:String = "1 Infinite Loop, Cupertino, CA 95014"
    var svlat:Double = 0
    var svlon:Double = 0
    

    @IBOutlet weak var countLabel: UILabel!
    
    
    func getLocation(forPlaceCalled address: String,
                     completion: @escaping(CLLocation?) -> Void) {
    
        let geocoder:CLGeocoder = CLGeocoder()
  
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error ?? "")
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                }
            })
    }

    override func loadView() {
        super.loadView()
        addressInput = countLabelText;
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation(forPlaceCalled:countLabelText) { placemark in
            if let place = placemark {
                self.svlat = place.coordinate.latitude
                self.svlon = place.coordinate.longitude
                print(self.svlat)
                print(self.svlon)
            }
            
        }
        //countLabel.text = countLabelText
        // Do any additional setup after loading the view.
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
