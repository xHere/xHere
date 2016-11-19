//
//  XHEREGooglePlacesServer.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/18/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHEREGooglePlacesServer: NSObject {
    
    static let sharedInstance = XHEREGooglePlacesServer()
    
    func getLocationBy(coordinates:PFGeoPoint, success:@escaping (_ locations :[POI]?)->(), failure: @escaping (Error?)->()) {
        
        
        self.getLocationBy(
            placeName: "",coordinates: coordinates,
            success: { (contentsArray:[POI]?) in
                
                success(contentsArray)
                
                
        },
            failure: { (error:Error?) in
                failure(error)
        })
    }
    
    
    func getLocationBy(placeName: String, coordinates:PFGeoPoint, success:@escaping ([POI]?)->(), failure: @escaping (Error?)->()) {
        
        
        let urlString = "\(kGoogleWebserviceBasePath)nearbysearch/json?key=\(kPFGoogleApiKey)&location=\(coordinates.latitude),\(coordinates.longitude)&radius=1000.0&rankby=prominence&sensor=true&name=\(placeName)"
        print(urlString)
        
        let encodedURL  = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        let url = URL(string:encodedURL!)
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let error = error {
                print(error.localizedDescription)
                failure(error)
            }
            else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        
                        if let allLocations = responseDictionary["results"] as? [NSDictionary] {
                            var locationList = [POI]()
                            
                            
                            
                            for lObj in allLocations
                            {
                                let locationObj = POI()
                                locationObj.initWithDictionary(dictionary: lObj)
                                locationList.append(locationObj)
                            }
                            success(locationList)
                        }
                        
                    }
                }
            }
        });
        task.resume()
        
    }
    


}
