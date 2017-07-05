//
//  FavoritesViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/27/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// MARK: FavoritesViewController: UIViewController

class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let favoriteIdentifier = "FavoriteCell"
    var favoritesArray = [FIRDataSnapshot]()
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        tableView.reloadData()
        //self.navigationController?.navigationBar.topItem?.title = "Here are your favorite beers"
 
    }
    override func viewDidLoad() {
        listenForUserAuthentication()
     
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    public func listenForUserAuthentication() {
        
        let uid = FIRAuth.auth()!.currentUser?.uid
        FIRDatabase.database().reference().child("users/users/individualusers").child(uid!).observe(.value) { (snapshot: FIRDataSnapshot) in
            
            self.favoritesArray = []
            for each in snapshot.children {
               
                self.favoritesArray.append(each as! FIRDataSnapshot)
                
            }
            
            self.tableView.reloadData()
  
        }
 
    }
    

}

// MARK: FavoritesViewController:  UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteIdentifier, for: indexPath)
    
        let beerSnapshot = favoritesArray[indexPath.row]
        let snapshotValue = beerSnapshot.value as? [String: AnyObject]
        
        var beer = snapshotValue?["beer"] as? [String:AnyObject]
        
        let name = beer?["name"] as? String
        
        cell.textLabel?.text = name

        return cell
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let ref = FIRDatabase.database().reference()
        let userid = FIRAuth.auth()!.currentUser?.uid
        if editingStyle == .delete {
            
            let beer = favoritesArray[indexPath.row].key
            ref.child("users").child("users/individualusers/").child(userid!).child(beer).removeValue()
            favoritesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
}

