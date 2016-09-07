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
	
	var mapView: GMSMapView!
	
	@IBAction func directionsTapped(_ sender: AnyObject) {
		if let url = URL(string: "comgooglemaps://?daddr=Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001"), UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.openURL(url)
		} else {
			UIApplication.shared.openURL(URL(string: "https://google.com/maps/dir//Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001")!)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let position = CLLocationCoordinate2D(latitude: 28.6177578, longitude: 77.2150013) //77.21500130000004
		let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17)
		mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
		view.addSubview(mapView)
		
		let marker = GMSMarker(position: position)
		marker.title = "Jawahar Bhawan"
		marker.snippet = "Raisina Road, Windsor Place,\nNew Delhi 110001"
		marker.appearAnimation = kGMSMarkerAnimationPop
		marker.map = mapView
		mapView.selectedMarker = marker
	}
	
	override func viewDidLayoutSubviews() {
		mapView.frame = view.frame
		mapView.padding.top = topLayoutGuide.length
		mapView.padding.bottom = bottomLayoutGuide.length
	}
}
