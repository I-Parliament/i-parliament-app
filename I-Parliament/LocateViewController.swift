//
//  LocateViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import WebKit

class LocateViewController: UIViewController {
	
	@IBOutlet weak var mapContainerView: UIView!
	
	var mapsInstalled: Bool {
		guard let url = URL(string: "comgooglemaps://") else {return false}
		return UIApplication.shared.canOpenURL(url)
	}
	
	@IBAction func directionsTapped(_ sender: AnyObject) {
		if mapsInstalled {
			UIApplication.shared.openURL(URL(string: "comgooglemaps://?daddr=Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001")!)
		} else {
			UIApplication.shared.openURL(URL(string: "https://google.com/maps/dir//Jawahar+Bhawan,+Raisina+Road,+Windsor+Place,+New+Delhi,+Delhi+110001")!)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//TODO: Add loading indicator (Large UIActivityIndicatorView)
		let webView = WKWebView(frame: view.frame)
		let headerOffset: CGFloat = 160
		let footerOffset: CGFloat = 14
		webView.frame.origin.y -= headerOffset //Move upwards by headeroffset
		webView.frame.size.height += headerOffset + footerOffset //Scale downwards by headeroffset + footeroffset
		webView.scrollView.isScrollEnabled = false
		webView.loadHTMLString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><body style=\"margin:0\"><iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3502.4004553877344!2d77.2128126152168!3d28.617757782423638!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390ce2b5d155be63%3A0x819d012e224ef827!2sJawahar+Bhawan%2C+Raisina+Road%2C+Windsor+Place%2C+New+Delhi%2C+Delhi+110001!5e0!3m2!1sen!2sin!4v1473058387895\" width=\"100%\" height=\"100%\" frameborder=\"0\"></iframe></body>", baseURL: nil)
		view.addSubview(webView)
	}
	
}
