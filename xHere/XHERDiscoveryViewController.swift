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
class XHERDiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentLocation : PFGeoPoint!
    var locations : [POI]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find a Place"
        self.setupTableView()
        

        
        PFGeoPoint.geoPointForCurrentLocation { (loc :PFGeoPoint?, error :Error?) in
            if error == nil{
                self.currentLocation = loc
                self.setUpMapView()
                self.getNearbyLocations()
            }
        }
    }

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Setup View
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
                
                let coordinate = CLLocationCoordinate2DMake(location.latitute,location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.placeName
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    // MARK: - Table view delegate
    
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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let neabyBountiesViewController = XHERENeabyBountiesViewController(nibName: "XHERENeabyBountiesViewController", bundle: nil)
        neabyBountiesViewController.location = self.locations?[indexPath.row]
        self.navigationController?.pushViewController(neabyBountiesViewController, animated: true)
        
    }
    
    // MARK: - Search Bar delegate

   
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLocationsWithPlace(searchText: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        self.view.endEditing(true)
    }
    // MARK: - API calls
    func fetchLocationsWithPlace(searchText : String){
        
       self.view.endEditing(true)
        
        
        XHEREGooglePlacesServer.sharedInstance.getLocationBy(
            placeName: searchText,coordinates: currentLocation,
            success: { (contentsArray:[POI]?) in
                
                if let contentsArray = contentsArray {
                    
                    self.locations = contentsArray
                    self.tableView.reloadData()
                    self.setUpMapView()
                }else{
                    print("No result found")
                }
        },
            failure: { (error:Error?) in
                
        })

    }
    func getNearbyLocations(){
        
       
        XHEREGooglePlacesServer.sharedInstance.getLocationBy(
            coordinates: currentLocation,
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
