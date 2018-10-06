//
//  ViewController.swift
//  ncmbLocation
//
//  Created by nakatsugawa on 2018/10/06.
//  Copyright © 2018 MOONGIFT. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var latLabel: UILabel!
	@IBOutlet weak var lngLabel: UILabel!
	
	var locationManager : CLLocationManager?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			manager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			break
		case .authorizedAlways, .authorizedWhenInUse:
			break
		}
	}
	
	@IBAction func tapStartButton(_ sender: UIButton) {
		if locationManager != nil { return }
		locationManager = CLLocationManager()
		locationManager!.delegate = self
		locationManager!.requestWhenInUseAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager!.startUpdatingLocation()
		}
		// tracking user location
		mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
		mapView.showsUserLocation = true
		mapView.removeAnnotations(mapView.annotations)
		
		let query = NCMBQuery(className: "Station")
		query?.findObjectsInBackground({(objects, err) in
			if err != nil {
			} else {
				let stations = objects as! [NCMBObject]
				var annotations: [MKPointAnnotation] = []
				for station in stations {
					let geo = station.object(forKey: "geo") as! NCMBGeoPoint
					let location = CLLocation.init(latitude: geo.latitude, longitude: geo.longitude)
					let annotation = MKPointAnnotation()
					annotation.coordinate = location.coordinate
					annotations.append(annotation)
				}
				self.mapView.addAnnotations(annotations)
			}
		})
	}
	
	@IBAction func tapStopButton(_ sender: UIButton) {
		guard let manager = locationManager else { return }
		manager.stopUpdatingLocation()
		manager.delegate = nil
		locationManager = nil
		latLabel.text = "latitude: "
		lngLabel.text = "longitude: "
		
		// untracking user location
		mapView.userTrackingMode = MKUserTrackingMode.none
		mapView.showsUserLocation = false
		mapView.removeAnnotations(mapView.annotations)
		
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let newLocation = locations.last else {
			return
		}
		
		let location:CLLocationCoordinate2D
			= CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
		let latitude = "".appendingFormat("%.4f", location.latitude)
		let longitude = "".appendingFormat("%.4f", location.longitude)
		latLabel.text = "latitude: " + latitude
		lngLabel.text = "longitude: " + longitude
		
		// update annotation
		mapView.removeAnnotations(mapView.annotations)
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = newLocation.coordinate
		mapView.addAnnotation(annotation)
		mapView.selectAnnotation(annotation, animated: true)
		
		// Showing annotation zooms the map automatically.
		mapView.showAnnotations(mapView.annotations, animated: true)
		
	}
}

