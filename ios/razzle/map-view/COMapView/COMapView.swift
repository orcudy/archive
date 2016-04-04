//
//  MapView.swift
//  COMapView
//
//  Created by Chris Orcutt on 8/23/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class COMapView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
    // MARK: MapViewProperties
    var annotation: MKPointAnnotation?
    var region: MKCoordinateRegion? {
        didSet {
            if let region = region {
                mapView.region = region
                
                if let annotation = annotation {
                    annotation.coordinate = region.center
                } else {
                    annotation = MKPointAnnotation()
                    annotation!.coordinate = region.center
                    mapView.addAnnotation(annotation!)
                }
            }
        }
    }
    var latitude: Float? {
        didSet {
            if let latitude = latitude {
                mapView.region.center.latitude = CLLocationDegrees(latitude)
                region = mapView.region
            }
        }
    }
    var longitude: Float? {
        didSet {
            if let longitude = longitude {
                mapView.region.center.longitude = CLLocationDegrees(longitude)
                region = mapView.region
            }
        }
    }
    var span: Float? {
        didSet {
            if let span = span {
                mapView.region.span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(span), longitudeDelta: CLLocationDegrees(span))
                region = mapView.region
            }
        }
    }
    
    //MARK: AddressBookProperties
    var name: String?
    var address = [NSObject : AnyObject]() {
        didSet {
            var text = ""
            if let name = name {
                text += "\(name)"
            }
            if let street = street {
                text += ", \(street)"
            }
            if let city = city {
                text += ", \(city)"
            }
            if let state = state {
                text += ", \(state)"
            }
            if let ZIP = ZIP {
                text += ", \(ZIP)"
            }
            if let country = country {
                text += ", \(country)"
            }
            footerLabel.text = text
        }
    }
    var street: String? {
        didSet {
            if let street = street {
                address[kABPersonAddressStreetKey] = street
            }
        }
    }
    var city: String? {
        didSet {
            if let city = city {
                address[kABPersonAddressCityKey] = city
            }
        }
    }
    var state: String? {
        didSet {
            if let state = state {
                address[kABPersonAddressStateKey] = state
            }
        }
    }
    var ZIP: String? {
        didSet {
            if let ZIP = ZIP {
                address[kABPersonAddressZIPKey] = ZIP
            }
        }
    }
    var country: String? {
        didSet {
            if let country = country {
                address[kABPersonAddressCountryKey] = country
            }
        }
    }
    
    //MARK: Initialization
    func baseInit() {
        NSBundle.mainBundle().loadNibNamed("COMapView", owner: self, options: nil)
        
        mapView.delegate = self
        
        self.footerView.layer.cornerRadius = 2
        self.footerView.layer.shadowColor = UIColor.grayColor().CGColor
        self.footerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.footerView.layer.shadowOpacity = 1
        self.footerView.layer.shadowRadius = 1
        self.footerView.layer.masksToBounds = false
        self.footerView.alpha = 0.90
        
        self.view.frame = bounds
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    //MARK: MapsApp
    @IBAction func openMapsApp(sender: AnyObject) {
        if let latitude = region?.center.latitude, longitude = region?.center.longitude, name = name {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
            var mapItem = MKMapItem(placemark: placemark)
            mapItem.name = name
            mapItem.openInMapsWithLaunchOptions(nil)
        }
    }
}

//MARK: MKMapViewDelegate
extension COMapView: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        annotationView.image = UIImage(named: "Marker")
        return annotationView
    }
}
