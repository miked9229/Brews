//
//  BreweryDBClient.swift
//  Brews
//
//  Created by Michael Doroff on 5/27/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class BreweryDBCLient {
    
    
    public func getForBeerData() {
        
        
        let session = URLSession.shared
        let urlString = "https://api.brewerydb.com/v2/beers?key=7d64d2655fe3c2f90b82dae866dea77b&format=json"
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        

        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
                
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
                
            }
            
            var parsedResult: [String:AnyObject]? = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                print("Could not parse JSON data")
                
            }
            
            guard let beerData = parsedResult?["data"] as? [[String:AnyObject]] else { return }
            
            
            self.loadToDataToFirebase(beersInformationArray: beerData)
        }
        
        task.resume()
        
    }
    
// MARK: Unwrapping Beer JSON Data
    
    fileprivate func loadToDataToFirebase(beersInformationArray:[[String: AnyObject]]) {
        let ref = FIRDatabase.database().reference()
        ref.child("Beers").childByAutoId().setValue(beersInformationArray)
        
    }

        
}
    
    
    
    
    

