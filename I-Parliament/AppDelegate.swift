//
//  AppDelegate.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window?.tintColor = UIColor(red:1.0, green:0.58, blue:0.0, alpha:1.0)
		if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
			let dict = NSDictionary(contentsOfFile: path),
			let key = dict["googlemaps"] as? String {
			GMSServices.provideAPIKey(key)
			print(GMSServices.openSourceLicenseInfo())
		}
		return true
	}


}

