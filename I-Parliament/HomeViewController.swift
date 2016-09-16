//
//  HomeViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	var index: Int!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var textView: UITextView!
	
	var infoItem: InfoItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = infoItem.image
		textView.text = infoItem.body
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textView.contentOffset.y = 0
		textView.flashScrollIndicators()
	}
	
}

