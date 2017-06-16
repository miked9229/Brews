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

// MARK: BreweruDBClient

class BreweryDBCLient {
    
    
    public func getForBeerData(_ completionHandler: @escaping(_ imageData: [String:AnyObject]? , _ error: String ) -> Void) {
        
        
        let session = URLSession.shared
        let urlString = "https://api.brewerydb.com/v2/beers?key=7d64d2655fe3c2f90b82dae866dea77b&format=json"
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        

        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            
            guard (error == nil) else {
                completionHandler(nil, "There was an error with your network request")
                print("There was an error with your request: \(String(describing: error))")
                return
                
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandler(nil, "There was an error requesting data")
                
                return
            }
            guard let data = data else {
                completionHandler(nil, "There was an error requesting data")
                return
                
            }
            
            var parsedResult: [String:AnyObject]? = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                print("Could not parse JSON data")
                
            }
            
            completionHandler(parsedResult, "")

        }
        
        task.resume()
        
    }
    
// MARK: Unwrapping Beer JSON Data
    
    public func loadToDataToFirebase(beersInformationArray:[[String: AnyObject]]) {
        let ref = FIRDatabase.database().reference()
        ref.database.reference()
        ref.child("Beers").setValue(nil)
        ref.child("Beers").childByAutoId().setValue(beersInformationArray)
        
    }

}
    
    
    
    
    

