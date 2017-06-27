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
import FirebaseDatabase


// MARK: LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UINavigationControllerDelegate

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UINavigationControllerDelegate {
    var currentUser: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFaceBookButtons()
        setUpGoogleButtons()
        setUpBackGroundImage()
        listenForUserAuthentication()
  
    }
    

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        showEmailAddress()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout occurred....")
    
    }

    
// MARK: Configure UI Elements
    
    fileprivate func setUpGoogleButtons() {
        
        let margins = view.layoutMarginsGuide
        let googleButton = GIDSignInButton()
        googleButton.style = .wide
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleButton)
        googleButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: view.frame.height * 0.80).isActive = true
        googleButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        googleButton.heightAnchor.constraint(equalTo: googleButton.widthAnchor, multiplier: 2.0).isActive = true
        GIDSignIn.sharedInstance().uiDelegate = self

        
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
    
// MARK: View Transition Methods
    func presentNextController() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        
        navigationController?.pushViewController(controller, animated: true)
        
    }

// MARK: Firebase Methods
    
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
    
    
    public func listenForUserAuthentication() {
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // 3
               self.performSegue(withIdentifier: "loginToList", sender: nil)

            }
        }
    }

}
