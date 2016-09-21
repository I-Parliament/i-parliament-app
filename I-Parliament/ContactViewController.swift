//
//  ContactViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import WebKit

class ContactViewController: UIViewController {

	@IBOutlet weak var contactTextView: UITextView!
	
	@IBAction func openURL(_ sender: UIButton) {
		guard let title = sender.currentTitle, let url = URL(string: title) else {return}
		UIApplication.shared.openURL(url)
	}
	
	var firstShow = true
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if firstShow {
			firstShow = false
			contactTextView.contentOffset.y = 0 //Fixes a bug that offsets the UITextView
			contactTextView.flashScrollIndicators()
		}
	}

}
