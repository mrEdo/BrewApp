//
//  HomeViewController.swift
//  BrewApp
//
//  Created by admin on 7/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBrew(_ sender: Any) {
        performSegue(withIdentifier: "showSearch", sender: self)
    }
    
    @IBAction func currentBrew(_ sender: Any) {
        performSegue(withIdentifier: "showCurrent", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let svc = segue.destination as! SearchViewController
        //svc.countLabel.text = "This was passed Along!"
        //wv.stateInfo = self.textfield.text!
        
        if segue.identifier == "showSearch",
            let destinationVC = segue.destination as? SearchViewController {
            destinationVC.countLabelText = searchInput.text!
        }

        else if segue.identifier == "showCurrent",
            let destinationVC = segue.destination as? SearchViewController {
            destinationVC.addressInput = "Hello World!"
        }
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
