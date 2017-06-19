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
import FirebaseAuth

// MARK: TabBarViewController: UITabBarViewController

class TabBarViewController: UITabBarController {
    var user: String!
    let activityIndicator = UIActivityIndicatorView()
    var alreadyGotInformation: Bool! = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    
    }
    public func raiseError(errorString: String) {
        let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        alreadyGotInformation = false
        present(alert, animated: true, completion: nil)

        
    }
    
    @IBAction func logOut(_ sender: Any) {
   
    let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as?
        LoginViewController

      
        
        try? FIRAuth.auth()?.signOut()
        
        present(vc!, animated: true, completion: nil)
 
    
    }
}
