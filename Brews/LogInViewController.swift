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


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    var currentUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpFaceBookButtons()
        setUpGoogleButtons()
        setUpBackGroundImage()
//        setUpTitle()
        
        let _ = FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.currentUser = user?.displayName
                self.configureDatabase()
                self.presentNextController()
                
                
            }
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        showEmailAddress()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    
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
    fileprivate func setUpTitle() {
        let margins = view.layoutMarginsGuide
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Brews"
        title.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        view.addSubview(title)
        title.topAnchor.constraint(equalTo: margins.topAnchor , constant: view.frame.height * 0.10).isActive = true
        title.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        title.textAlignment = .center
        title.textColor = UIColor.cyan
    
    }
    fileprivate func presentNextController() {
       
        print("Trying to present this view controller")
        let controller = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        present(controller, animated: true) {
            print("Hello")
        }

        
    }
    public func configureDatabase() {
        let practicedict = ["Dog": "Bill", "User": currentUser]
        
        let ref = FIRDatabase.database().reference()
        ref.child("messages").childByAutoId().setValue(practicedict)
 
        
    }
    
    
// MARK: Configure UI Elements
    
    
}

