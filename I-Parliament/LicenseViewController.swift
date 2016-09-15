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
	
	override func viewDidLoad() {
        super.viewDidLoad()
		licenseTextView.text = licenseText
		licenseTextView.contentOffset.y = 0
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		licenseTextView.flashScrollIndicators()
	}

}
