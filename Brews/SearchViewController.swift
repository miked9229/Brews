//
//  SearchViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/27/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    
    // MARK: Properties
    var ref: FIRDatabaseReference!
    var beers: [FIRDataSnapshot]! = []
    fileprivate var _refHandle: FIRDatabaseHandle!
    @IBOutlet weak var beerTable: UITableView!
    let beerIdentifier = "beerIdentifier"
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
         setupDatabase()
    }
    
    
    // MARK: Config

    func setupDatabase() {
        ref = FIRDatabase.database().reference()
       _refHandle = ref.child("Beers").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
        
        
        for each in snapshot.children {
            self.beers.append((each as? FIRDataSnapshot)!)
            
        }
      
        self.beerTable.reloadData()
    }
        
    }

}
        
// MARK: SearchViewController: UITableViewDelegate, UITableViewDataSource
        
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = beerTable.dequeueReusableCell(withIdentifier: beerIdentifier, for: indexPath)
        
        let beerSnapshot = beers[indexPath.row]
        
        var key = beerSnapshot.key
        
        let snapshotValue = beerSnapshot.value as? [String: AnyObject]
        
        cell.textLabel?.text = snapshotValue?["name"] as! String?
        

        
        return cell
    }
    
}
        

    

    
