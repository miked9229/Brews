//
//  ViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/13/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit
import FBSDKLoginKit



class ViewController: UIViewController {

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    
    let loginButton = FBSDKLoginButton()
    view.addSubview(loginButton)
    loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
    
    }



}

