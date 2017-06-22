//
//  RandomBeerViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/27/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

// MARK: RandomBeerViewController: UIViewController

class RandomBeerViewController: UIViewController {
    
    var beersSnapshot = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var randomNumber: Int!
    var shouldTransition: Bool! = false
    
    override func viewWillAppear(_ animated: Bool) {
        beersSnapshot = []
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Click to get a random beer!"
        ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
        
    }
    
    @IBAction func chooseARandomBeer(_ sender: Any) {
        GetBeerData()


    }
    
    public func GetBeerData() {
        
            shouldTransition = true
            ref = FIRDatabase.database().reference()
            _refHandle = ref.child("Beers").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
                
                self.beersSnapshot = []
                for each in snapshot.children {
                    self.beersSnapshot.append((each as? FIRDataSnapshot)!)
                    
            
            }
                self.randomNumber = Int(arc4random_uniform(UInt32(self.beersSnapshot.count)) + 1 )
               
                if self.beersSnapshot.count != 0 && self.shouldTransition  {
                        self.transitionToSelectedBeerViewController(beer: self.beersSnapshot[self.randomNumber])
                        self.shouldTransition = false
            
                }
            }
        
    }
    func transitionToSelectedBeerViewController(beer: FIRDataSnapshot) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedBeerViewController") as? SelectedBeerViewController
        
        vc?.selectedBeer = beer
        
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
        
    }
    
}
