//
//  LicenseViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 14/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

	@IBOutlet weak var licenseTextView: UITextView!
	
	var licenseText: String!
	
	var firstShow = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		licenseTextView.text = licenseText
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if firstShow {
			firstShow = false
			licenseTextView.contentOffset.y = -topLayoutGuide.length
			licenseTextView.flashScrollIndicators()
		}
	}

}
