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
        setUpBackGroundImage()

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        showEmailAddress()
        let controller = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        present(controller, animated: true) {
            print("Hello")
        }
        
        
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
    
     let margins = view.layoutMarginsGuide
    let loginButton = FBSDKLoginButton()
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loginButton)
    loginButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: view.frame.height * 0.75).isActive = true
    loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    loginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    loginButton.heightAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 2.0).isActive = true
    loginButton.delegate = self
    loginButton.readPermissions = ["email", "public_profile"]

    }
    fileprivate func setUpGoogleButtons() {
        
        let margins = view.layoutMarginsGuide
        let GoogleButton = GIDSignInButton()
        GoogleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GoogleButton)
        GoogleButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: view.frame.height * 0.80).isActive = true
        GoogleButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        GoogleButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        GoogleButton.heightAnchor.constraint(equalTo: GoogleButton.widthAnchor, multiplier: 2.0).isActive = true
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    fileprivate func setUpBackGroundImage() {
        let background = UIImage(named: "BackgroundImage")
        
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
    }
}

