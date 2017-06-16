//
//  TableViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/18/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

// MARK: TabBarViewController: UITabBarViewController

class TabBarViewController: UITabBarController {
    var user: String!
    let activityIndicator = UIActivityIndicatorView()
    var alreadyGotInformation: Bool! = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

     
// Need to implemenet pull to refresh data
        if !alreadyGotInformation {
           
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .gray
            view.addSubview(activityIndicator)
            view.alpha = 0.50
            activityIndicator.startAnimating()
            BreweryDBCLient().getForBeerData() { (data, error) in
                if error == "" {
                    guard let beerData = data?["data"] as? [[String:AnyObject]] else { return }
                    BreweryDBCLient().loadToDataToFirebase(beersInformationArray: beerData)
                    self.activityIndicator.stopAnimating()
                    self.view.alpha = 1.0
                    self.alreadyGotInformation = true
        
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.raiseError(errorString: error)
                    self.view.alpha = 1.0
                    
                    
                }
            }
            
        }

    
    }
    public func raiseError(errorString: String) {
        let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        alreadyGotInformation = false
        present(alert, animated: true, completion: nil)

        
    }
    
}
