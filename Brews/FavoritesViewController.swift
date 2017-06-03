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


class FavoritesViewController: UIViewController {
    var currentUser: String!
    @IBOutlet weak var tableView: UITableView!
    let favoriteIdentifier = "FavoriteCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listenForUserAuthentication()
    }
    

    
    public func listenForUserAuthentication() {
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.currentUser = user?.email
                print(self.currentUser)
                
            }
        }
    }

}

// MARK: FavoritesViewController:  UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteIdentifier, for: indexPath)
    
    
        return cell
    }
}

