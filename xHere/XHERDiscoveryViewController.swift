//
//  XHERDiscoveryViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import MapKit
import Parse
class XHERDiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentLocation = CLLocationCoordinate2DMake(37.785771,-122.406165)
    var locations : [POI]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DISCOVER"
        self.setupTableView()
        self.setUpMapView()
        self.getNearbyLocations()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        self.edgesForExtendedLayout = []
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "POIViewCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "POIViewCell")
    }
    
    func setUpMapView(){
        
        
        let initialLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        if self.locations != nil{
            for location in self.locations!{
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = currentLocation
                annotation.title = location.placeName
                self.mapView.addAnnotation(annotation)
            }
        }
       
        
       
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if locations != nil{
            return locations!.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "POIViewCell", for: indexPath) as! POIViewCell
        cell.location = self.locations?[indexPath.row]
        
        return cell
    }
    func getNearbyLocations(){
        
        let myGeoPoint = PFGeoPoint(latitude: 37.785771, longitude: -122.406165)
        XHEREGooglePlacesServer.sharedInstance.getLocationBy(
            coordinates: myGeoPoint,
            success: { (contentsArray:[POI]?) in
                
                if let contentsArray = contentsArray {
                    
                    self.locations = contentsArray
                    self.tableView.reloadData()
                    self.setUpMapView()
                }
        },
            failure: { (error:Error?) in
                
        })
    }
    
   
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
