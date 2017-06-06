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
    var user: String?
    var ref: FIRDatabaseReference!
    var beers: [FIRDataSnapshot]! = []
    fileprivate var _refHandle: FIRDatabaseHandle!
    @IBOutlet weak var beerTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let beerIdentifier = "beerIdentifier"
    var isSearching = false
    var filteredData = [FIRDataSnapshot]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        super.viewWillAppear(animated)
        self.searchBar.delegate = self
        searchBar.returnKeyType = .done
         self.navigationController?.navigationBar.topItem?.title = "Hi \((FIRAuth.auth()!.currentUser?.displayName)!), select a beer!"
        
    }
    
    override func viewDidLoad() {
         setupDatabase()
  
    }
    
    
    // MARK: Config

    func setupDatabase() {
        ref = FIRDatabase.database().reference()
       _refHandle = ref.child("Beers").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
        
        self.beers = []
        for each in snapshot.children {
            self.beers.append((each as? FIRDataSnapshot)!)
            
            }
        print(self.beers.count)
        self.beerTable.reloadData()
        }
        
    }

}
        
// MARK: SearchViewController: UITableViewDelegate, UITableViewDataSource
        
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredData.count
        }
        
        return beers.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = beerTable.dequeueReusableCell(withIdentifier: beerIdentifier, for: indexPath)
        
        if isSearching {
            
            let beerSnapshot = filteredData[indexPath.row]
            let snapshotValue = beerSnapshot.value as? [String: AnyObject]
            cell.textLabel?.text = snapshotValue?["name"] as! String?
        } else {
            
            let beerSnapshot = beers[indexPath.row]
            let snapshotValue = beerSnapshot.value as? [String: AnyObject]
            cell.textLabel?.text = snapshotValue?["name"] as! String?
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedBeer: FIRDataSnapshot!
        
        
        
        if isSearching {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedBeer = filteredData[indexPath.row]
            transitionToSelectedBeerViewController(beer: selectedBeer)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedBeer = beers[indexPath.row]
            transitionToSelectedBeerViewController(beer: selectedBeer)
        }
        
    }
    
    func transitionToSelectedBeerViewController(beer: FIRDataSnapshot) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedBeerViewController") as? SelectedBeerViewController
        
        vc?.selectedBeer = beer
        
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    


}
// MARK: SearchViewController: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            beerTable.reloadData()
            
        } else {
            isSearching = true
            filteredData = returnArrayOfFiltertedData(searchString: searchBar.text)
            beerTable.reloadData()
        }
    }

    fileprivate func returnArrayOfFiltertedData(searchString: String?) -> [FIRDataSnapshot] {

        var newFiltertedData: [FIRDataSnapshot] = []
        
        for each in beers {
            
        var beerSnapShotValue = each.value as? [String: AnyObject]
        let nameOfBeer = beerSnapShotValue?["name"] as! String?
            if (nameOfBeer?.contains(searchString!))!  {
                newFiltertedData.append(each)
            }
            
            
        }
        
        return newFiltertedData
    }
    
    
    
}
        

    

    
