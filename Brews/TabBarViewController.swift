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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        BreweryDBCLient().getForBeerData()
        
        
        
    }

    
}
