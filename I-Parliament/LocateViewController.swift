//
//  LocateViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import GoogleMaps

class LocateViewController: UIViewController {
	
	@IBOutlet weak var mapContainerView: UIView!
	
	@IBAction func directionsTapped(_ sender: AnyObject) {
		if let url = URL(string: "comgooglemaps://?daddr=Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001"), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.openURL(url)
		} else {
			UIApplication.shared.openURL(URL(string: "https://google.com/maps/dir//Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001")!)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let position = CLLocationCoordinate2D(latitude: 28.6177578, longitude: 77.21500130000004)
		
		let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.5)
		
		let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
		
		let marker = GMSMarker(position: position)
		marker.title = "Jawahar Bhawan"
		marker.snippet = "Raisina Road, Windsor Place, New Delhi, Delhi 110001"
		marker.map = mapView
		
		mapView.selectedMarker = marker
		
		view.addSubview(mapView)
	}
}
