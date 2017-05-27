//
//  BreweryDBClient.swift
//  Brews
//
//  Created by Michael Doroff on 5/27/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation

class BreweryDBCLient {
    
    
    public func getForBeerData() {
        
        
        let session = URLSession.shared
        let urlString = "https://api.brewerydb.com/v2/ingredient/434?key=7d64d2655fe3c2f90b82dae866dea77b&format=json"
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        print(urlRequest)
        
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
            
            var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                print("Could not parse JSON data")
                
            }
            
            print(parsedResult)
            
            
            
        }
        
        task.resume()
        
    }

        
}
    
    
    
    
    

