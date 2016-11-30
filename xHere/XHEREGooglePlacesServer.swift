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
    
    enum RadiusType: Double {
        case nearby = 500.00, farPlaces = 200.00
    }
    func getPlaceDetails(placeId:String,success:@escaping (_ locations :[POI]?)->(), failure: @escaping (Error?)->()){
        
        
        let urlString = "\(kGoogleWebserviceBasePath)details/json?placeid=\(placeId)&key=\(kPFGoogleApiKey)"
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
                        
                        if let allLocations = responseDictionary["result"] as? NSDictionary {
                            var locationList = [POI]()
                            
                            let locationObj = POI()
                            locationObj.initWithDictionary(dictionary: allLocations)
                            locationList.append(locationObj)
                            
                           
                            success(locationList)
                        }
                        
                    }
                }
            }
        });
        task.resume()

    }
    func getLocationBy(coordinates:PFGeoPoint,radius:RadiusType, success:@escaping (_ locations :[POI]?)->(), failure: @escaping (Error?)->()) {
        
        
        self.getLocationBy(
            placeName: "",radius : radius ,coordinates: coordinates,
            success: { (contentsArray:[POI]?) in
                
                success(contentsArray)
                
                
        },
            failure: { (error:Error?) in
                failure(error)
        })
    }
     func getSearchPlaces(placeName: String, success:@escaping ([POI]?)->(), failure: @escaping (Error?)->()) {
        
        let urlString = "\(kGoogleWebserviceBasePath)autocomplete/json?key=\(kPFGoogleApiKey)&location=\(37.41294),\(-121.938853)&radius=\(200000)&input=\(placeName)"
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
                        
                        if let allLocations = responseDictionary["predictions"] as? [NSDictionary] {
                            var locationList = [POI]()
                            
                            
                            
                            for lObj in allLocations
                            {
                                let locationObj = POI()
                                locationObj.initSearchDictionary(dictionary: lObj)
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
    
    func getLocationBy(placeName: String,radius:RadiusType, coordinates:PFGeoPoint, success:@escaping ([POI]?)->(), failure: @escaping (Error?)->()) {
        
       
        
        let urlString = "\(kGoogleWebserviceBasePath)nearbysearch/json?key=\(kPFGoogleApiKey)&location=\(coordinates.latitude),\(coordinates.longitude)&radius=\(radius.rawValue)&name=\(placeName)"
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
    class func geocodeAddressString(_ address:String, completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error == nil{
                if (placemarks?.count)! > 0{
                    completion((placemarks?[0]), error as NSError?)
                }
            }
            else{
                completion(nil, error as NSError?)
            }
        })
    }
    


}
