//
//  HomeViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textView.contentOffset.y = 0
		textView.flashScrollIndicators()
	}

}

