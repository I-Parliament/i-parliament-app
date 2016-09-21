//
//  HomeViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var textView: UITextView!
	
	var index: Int!
	var infoItem: InfoItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.image = infoItem.image
		textView.text = infoItem.body
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		textView.contentOffset.y = 0
		textView.flashScrollIndicators()
	}
	
}

