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
    
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentLocation : PFGeoPoint!
    var locations : [POI]?
    var autoComplete : [POI]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find a Place"
        self.setupTableView()
        autoCompleteTableView.isHidden = true

        
        PFGeoPoint.geoPointForCurrentLocation { (loc :PFGeoPoint?, error :Error?) in
            if error == nil{
                self.currentLocation = loc
                self.setUpMapView()
                self.getNearbyLocations(geoPoint: self.currentLocation)
            }
        }
    }

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Setup View
    func setupTableView() {
        self.edgesForExtendedLayout = []
       
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "POIViewCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "POIViewCell")
        
        self.autoCompleteTableView.estimatedRowHeight = 100
        self.autoCompleteTableView.rowHeight = UITableViewAutomaticDimension
        let autoCompleteCellNib = UINib(nibName: "XHEREAutoCompleteCell", bundle: nil)
        self.autoCompleteTableView.register(autoCompleteCellNib, forCellReuseIdentifier: "AutoCompleteCell")
    }
    
    func setUpMapView(){
        
        
       
        mapView.removeAnnotations(mapView.annotations)
        mapView.showsUserLocation = true
        if self.locations != nil{
            for location in self.locations!{
                
                let coordinate = CLLocationCoordinate2DMake(location.latitute,location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.placeName
                self.mapView.addAnnotation(annotation)
            }
        }
        
       
       
        let yourAnnotationArray = mapView.annotations
        mapView.showAnnotations(yourAnnotationArray, animated: true)
       // mapView.setRegion(coordinateRegion, animated: true)

    }
    // MARK: - Table view delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tableView==self.tableView){
            if locations != nil{
                return locations!.count
            }else{
                return 0
            }
        }else{
            if autoComplete != nil{
                return autoComplete!.count
            }else{
                return 0
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoCompleteTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell", for: indexPath) as! XHEREAutoCompleteCell
            cell.autoComplete = self.autoComplete?[indexPath.row]
            return cell

            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POIViewCell", for: indexPath) as! POIViewCell
            cell.location = self.locations?[indexPath.row]
            return cell

        }
       
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView==self.tableView){
            let neabyBountiesViewController = XHERENeabyBountiesViewController(nibName: "XHERENeabyBountiesViewController", bundle: nil)
            neabyBountiesViewController.location = self.locations?[indexPath.row]
            self.navigationController?.pushViewController(neabyBountiesViewController, animated: true)
        }else{
            
            let location = autoComplete?[indexPath.row]
            XHEREGooglePlacesServer.geocodeAddressString((location?.placeDescription)!, completion: { (placemark, error) -> Void in
                if (placemark?.location?.coordinate) != nil {
                    
                    self.autoCompleteTableView.isHidden = true
                    self.searchBar.text = location?.placeDescription
                    self.view.endEditing(true)
                    self.getPlaceDeatils(placeID: (location?.googlePlaceID)!)
                    
                }
            })
        }
       
        
    }
    
    // MARK: - Search Bar delegate

    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        autoCompleteTableView.isHidden = false
         fetchLocationsWithPlace(searchText: searchBar.text!)
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            
            //self.getNearbyLocations(geoPoint: currentLocation)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchLocationsWithPlace(searchText: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        self.getNearbyLocations(geoPoint: currentLocation)
        self.searchBar.text = ""
        autoCompleteTableView.isHidden = true
        self.view.endEditing(true)
    }
    // MARK: - API calls
    func fetchLocationsWithPlace(searchText : String){
        
      // self.view.endEditing(true)
        
        
//        XHEREGooglePlacesServer.sharedInstance.getLocationBy(
//            placeName: searchText,radius : .farPlaces,coordinates: currentLocation,
//            success: { (contentsArray:[POI]?) in
//                
//                if let contentsArray = contentsArray {
//                    
//                    self.locations = contentsArray
//                    self.tableView.reloadData()
//                    self.setUpMapView()
//                }else{
//                    print("No result found")
//                }
//        },
//            failure: { (error:Error?) in
//                
//        })
        
        XHEREGooglePlacesServer.sharedInstance.getSearchPlaces(placeName: searchText, success: { (locations :[POI]?) in
            if let locations = locations {
                
                self.autoComplete = locations
                self.autoCompleteTableView.reloadData()
                
            }else{
                print("No result found")
            }
            
        
        }) { (error : Error?) in
        
        }

    }
    func getNearbyLocations(geoPoint : PFGeoPoint){
        
       
        XHEREGooglePlacesServer.sharedInstance.getLocationBy(
            coordinates: geoPoint,radius: .nearby,
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
    func getPlaceDeatils(placeID:String){
        
        XHEREGooglePlacesServer.sharedInstance.getPlaceDetails(placeId: placeID, success: { (locationDetail : [POI]?) in
            
            
            if let locationDetail = locationDetail {
                
                self.locations = locationDetail
                self.tableView.reloadData()
                self.setUpMapView()
            }
            
            
        }) { (error : Error?) in
            print(error.debugDescription)
        }
    }
    func isAutoComplete(isAutoComplete :  Bool){
        if isAutoComplete{
            self.autoCompleteTableView.isHidden = false
            
        }else{
            self.autoCompleteTableView.isHidden = true
            self.view.endEditing(true)
        }
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
