//
//  SelectedBeerViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/29/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


// MARK: SelectedBeerViewController: UIViewController

class SelectedBeerViewController: UIViewController {
    
    // MARK: Properties
    var selectedBeer: FIRDataSnapshot!
    var currentUser: String!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    let storage = FIRStorage.storage()
    @IBOutlet weak var selectedBeerAlcContent: UILabel!
    @IBOutlet weak var UserFavoritesBar: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBeer()
        downloadImage()
//       disableFavoritesButton()
        listenForUserAuthentication()
       
        
    }

    
    fileprivate func setUpBeer() {
        let snapshotValue = selectedBeer.value as? [String: AnyObject]
        beerName.text = snapshotValue?["name"] as! String?
        var style = snapshotValue?["style"] as? [String: AnyObject]
        
        if let alcoholContent = style?["abvMax"] as! String? {
            selectedBeerAlcContent.text = alcoholContent + "%"
        } else {
            selectedBeerAlcContent.text = "Not available"
        }
        

        
    }
    
    fileprivate func disableFavoritesButton() {
        UserFavoritesBar.isEnabled = false
    
    }
    fileprivate func downloadImage() {
        let storageRef = storage.reference()
         let snapshotValue = selectedBeer.value as? [String: AnyObject]
        let id = snapshotValue?["id"] as! String?
        let beerRef = storageRef.child( id! + ".jpg")
        
        beerRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
               print(error)
               return
            }
            let image = UIImage(data: data!)
            self.beerImage.image = image
            
        }
    
    }
    
    public func listenForUserAuthentication() {
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // 3
                self.currentUser = user?.email
                
            }
        }
    }

    
    @IBAction func addToFavorites(_ sender: Any) {
        
       var userDict = [String: [String: Any]]()
       let ref = FIRDatabase.database().reference()
       let selectedBeerDict = selectedBeer.value as? [String: Any]
       let userid = FIRAuth.auth()!.currentUser?.uid
        
       let beerName = self.beerName.text!
        
        userDict[beerName] = selectedBeerDict
        
        print(userid)
        
       ref.child("users").child("users/individualusers/").child(userid!).childByAutoId().updateChildValues(userDict)
        
        
    
        
        
        
      
        
    }
    
    
    
    
}
