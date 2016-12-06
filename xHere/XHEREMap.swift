//
//  XHEREMap.swift
//  xHere
//
//  Created by Ruchit Mehta on 12/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import MapKit
class XHEREMap: UIView,MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locations : [XHERBounty]?

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView = Bundle.main.loadNibNamed("XHEREMap", owner: self, options: nil)?[0] as! UIView
        xibView.frame = self.bounds
        //xibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(xibView)
        if self.locations != nil{
            var index = 0
            for  location in self.locations!{
                index += 1
                
                
                let coordinate = CLLocationCoordinate2DMake((location.bountyGeoPoint?.latitude)!,(location.bountyGeoPoint?.latitude)!)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "sdffs"
                annotation.subtitle = "\(index)"
                self.mapView.addAnnotation(annotation)
                let viewI = mapView.view(for: annotation)
                viewI?.image = selectedPinImage
                
            }
            let yourAnnotationArray = mapView.annotations
            mapView.showAnnotations(yourAnnotationArray, animated: true)
        }

    }
    
    

}
