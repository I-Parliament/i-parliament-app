//
//  AppDelegate.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import GoogleMaps

enum ShortcutIdenitifier: String {
	case locate
	case blog
	case downloads
	case contacts
	
	init?(fullIdentifier: String) {
		guard let identifier = fullIdentifier.components(separatedBy: ".").last else {return nil}
		self.init(rawValue: identifier)
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window?.tintColor = UIColor(red:1.0, green:0.58, blue:0.0, alpha:1.0)
		if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
			let dict = NSDictionary(contentsOfFile: path),
			let key = dict["googlemaps"] as? String {
			GMSServices.provideAPIKey(key)
		}
		
		if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
			handleShortcut(shortcutItem, hasLaunched: false)
			return false
		}
		
		return true
	}
	
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		completionHandler(handleShortcut(shortcutItem, hasLaunched: true))
	}
	
	@discardableResult func handleShortcut(_ shortcutItem: UIApplicationShortcutItem, hasLaunched: Bool) -> Bool {
		guard let type = ShortcutIdenitifier(fullIdentifier: shortcutItem.type),
			let splashScreenController = window?.rootViewController as? SplashScreenViewController
			else {return false}
		
		let indexToSelect: Int
		
		switch type {
		case .locate:
			indexToSelect = 1
		case .blog:
			indexToSelect = 2
		case .downloads:
			indexToSelect = 3
		case .contacts:
			indexToSelect = 4
		}
		
		if hasLaunched { //Root tab bar controller already exists, set it directly
			splashScreenController.rootTabBarController?.selectedIndex = indexToSelect
		} else { //Specify that the splashScreenController should select this index when the animation is done
			splashScreenController.tabBarControllerIndex = indexToSelect
		}
		
		return true
	}

}

