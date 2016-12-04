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

let kTabbarHeight:Int = 0
let selectedPinImage = UIImage(named: "pinselected")
let pinImage = UIImage(named: "pin")

class XHERDiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var currentLocation : PFGeoPoint!
    var locations : [POI]?
    var autoComplete : [POI]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Find a Place"
        self.navigationController?.navigationBar.isHidden = true
        self.setupCollectionView()
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
       
      
        
        self.autoCompleteTableView.estimatedRowHeight = 100
        self.autoCompleteTableView.rowHeight = UITableViewAutomaticDimension
        let autoCompleteCellNib = UINib(nibName: "XHEREAutoCompleteCell", bundle: nil)
        self.autoCompleteTableView.register(autoCompleteCellNib, forCellReuseIdentifier: "AutoCompleteCell")
    }
    
    func setUpMapView(){
        
        
       
        mapView.removeAnnotations(mapView.annotations)
        mapView.showsUserLocation = true
        if self.locations != nil{
            var index = 0
            for  location in self.locations!{
                index += 1
                
                let coordinate = CLLocationCoordinate2DMake(location.latitute,location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.placeName
                annotation.subtitle = "\(index)"
                self.mapView.addAnnotation(annotation)
                
            }
        }
        
        let yourAnnotationArray = mapView.annotations
        mapView.showAnnotations(yourAnnotationArray, animated: true)
       

    }
    func setupCollectionView() {
        
        let nib = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "LocationCollectionViewCell")
        self.collectionViewHeightConstraint.constant = self.view.frame.size.height*0.25
        self.collectionViewBottomConstraint.constant = CGFloat(kTabbarHeight)
       
        
    }

    // MARK: - Map view delegate
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation
        {
            return
        }
        self.deselectAllPins()
        view.image = selectedPinImage
        //let pTitle = ((view.annotation?.title)!)!
        let pTitle = ((view.annotation?.subtitle)!)!
        let index = Int.init(pTitle)
        let bIndex = index! - 1
        let indexPath : IndexPath = NSIndexPath(row: bIndex, section: 0) as IndexPath
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
       
        self.deselectAllPins()
    }
    func deselectAllPins(){
        
        
        for annotation in mapView.annotations {
            
            
            let viewI = mapView.view(for: annotation)
            if(viewI != nil){
                
                if (viewI?.isKind(of: MKAnnotationView.self))!
                {
                    viewI?.image = pinImage
                    
                }
            }
            
        }
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        if annotationView?.annotation is MKUserLocation
        {
            print("uerewjew fjksd fkldsjf d*********'")
        }else{
            annotationView!.image = pinImage
        }
        
        
        return annotationView
    }
    // MARK: - Table view delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
            if autoComplete != nil{
                return autoComplete!.count
            }else{
                return 0
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
        
//        if(tableView==self.tableView){
//            let neabyBountiesViewController = XHERENeabyBountiesViewController(nibName: "XHERENeabyBountiesViewController", bundle: nil)
//            neabyBountiesViewController.location = self.locations?[indexPath.row]
//            self.navigationController?.pushViewController(neabyBountiesViewController, animated: true)
//        }else{
        
            let location = autoComplete?[indexPath.row]
            XHEREGooglePlacesServer.geocodeAddressString((location?.placeDescription)!, completion: { (placemark, error) -> Void in
                if (placemark?.location?.coordinate) != nil {
                    
                    self.autoCompleteTableView.isHidden = true
                    self.searchTextField.text = location?.placeDescription
                    self.view.endEditing(true)
                    self.getPlaceDeatils(placeID: (location?.googlePlaceID)!)
                    
                }
            })
        //}
       
        
    }
    
    // MARK: - Search Bar delegate

    @IBAction func seachTextChanged(_ sender: UITextField) {
        autoCompleteTableView.isHidden = false
        fetchLocationsWithPlace(searchText: sender.text!)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    
        fetchLocationsWithPlace(searchText: textField.text!)
        return true
    }
    
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
        
    
        
        XHEREGooglePlacesServer.sharedInstance.getSearchPlaces(placeName: searchText, success: { (locations :[POI]?) in
            if let locations = locations {
                self.autoCompleteTableView.isHidden = false
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
                    self.collectionView.reloadData()
                    if((self.locations?.count)!>0){
                        let indexpath = IndexPath(row: 0, section: 0)
                        self.collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: false)
                    }
                    self.setUpMapView()
                }
        },
            failure: { (error:Error?) in
                
        })
    }
    func getPlaceDeatils(placeID:String){
        
        XHEREGooglePlacesServer.sharedInstance.getPlaceDetails(placeId: placeID, success: { (locationDetail : [POI]?) in
            
            
            if let locationDetail = locationDetail {
                

            
                self.getNearbyLocations(geoPoint: locationDetail[0].geoPoint!)
            }
            
            
        }) { (error : Error?) in
            print(error.debugDescription)
        }
    }
    
    // MARK: - Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if self.locations != nil{
            return self.locations!.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let neabyBountiesViewController = XHERENeabyBountiesViewController(nibName: "XHERENeabyBountiesViewController", bundle: nil)
        neabyBountiesViewController.location = self.locations?[indexPath.row]
        self.navigationController?.pushViewController(neabyBountiesViewController, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
        cell.location = self.locations?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        _ = cell as! LocationCollectionViewCell
        //collectionCell.imageView.layer.cornerRadius = collectionCell.bounds.size.height/2
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: collectionView.bounds.size.width-80, height: collectionView.bounds.size.height-20)
       
        return cellSize
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(10,10,10,10)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.collectionView != nil){
            var insets = self.collectionView.contentInset
            let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
            insets.left = value
            insets.right = value
            self.collectionView.contentInset = insets
            self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        print("Visible indexpath \(visibleIndexPath)")
        
        let location = self.locations?[visibleIndexPath.row]
        
        let latitude:CLLocationDegrees = (location?.latitute)!
        
        let longitude:CLLocationDegrees = (location?.longitude)!
        
        let latDelta:CLLocationDegrees = 0.008
        
        let lonDelta:CLLocationDegrees = 0.008
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let locationCord = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region = MKCoordinateRegionMake(locationCord, span)
        
        

      
        
        self.highlightPin(indexRow: visibleIndexPath.row)
       
    
        mapView.setRegion(region, animated: true )
    }

    func highlightPin(indexRow:Int){
        
        for annotation in mapView.annotations {
            
            
            let viewI = mapView.view(for: annotation)
            
            let pTitle = annotation.subtitle
            //print(annotation.title)
            if pTitle != nil && viewI != nil{
                
                if viewI?.annotation is MKUserLocation
                {
                    
                }else{
                    
                    
                    let index = Int.init(pTitle!!)
                    if(index!-1 == indexRow){
                        print("Selected pin is \(pTitle) : \(annotation.title)")
                        DispatchQueue.main.async{
                            viewI?.image = selectedPinImage
                        }
                        self.mapView.selectAnnotation(annotation, animated: true)
                        
                    }else{
                        DispatchQueue.main.async{
                            viewI?.image = pinImage
                        }
                    }
                }
                
                
            }
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
