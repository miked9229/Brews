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


class TabBarViewController: UITabBarController {
    var user: String!
    let activityIndicator = UIActivityIndicatorView()
    var isConnectedToNetwork: Bool! = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
     
        if isConnectedToNetwork {
            BreweryDBCLient().getForBeerData() { (data, error) in
                if error == "" {
                    guard let beerData = data?["data"] as? [[String:AnyObject]] else { return }
                    BreweryDBCLient().loadToDataToFirebase(beersInformationArray: beerData)
                    self.activityIndicator.stopAnimating()
                    
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.raiseError(errorString: error)
                    
                }
            }
            
        }

    
    }
    public func raiseError(errorString: String) {
        let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        isConnectedToNetwork = false
        
        
        
        present(alert, animated: true, completion: nil)

        
    }
    
}
