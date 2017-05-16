//
//  ViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/13/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase




class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setUpFaceBookButtons()
        setUpGoogleButtons()
    
   
        

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        
        showEmailAddress()
        
        
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook...")
    }

    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {
                print("Something went wrong", error ?? "")
            }
            
            print("Sucessfully logged in with users", user ?? "")
            
        })
        
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, err) in
            
            
            if err != nil {
                print("Failed to start graph request")
                return
            }
        
            
        }
        
    }
    
    fileprivate func setUpFaceBookButtons() {
    
    
    let loginButton = FBSDKLoginButton()
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loginButton)
    loginButton.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: view.frame.width, height: 50)
    loginButton.delegate = self
    loginButton.readPermissions = ["email", "public_profile"]
    
    
    let horizontalConstraint = loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let verticalConstraint = loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    let widthConstraint = loginButton.widthAnchor.constraint(equalToConstant: view.frame.width)
    let heightConstraint = loginButton.heightAnchor.constraint(equalToConstant: 100)
    NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

    }
    fileprivate func setUpGoogleButtons() {
        
        let GoogleButton = GIDSignInButton()
        GoogleButton.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: view.frame.width, height: 50)
        view.addSubview(GoogleButton)
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }


    
    
}

