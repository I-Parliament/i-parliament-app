//
//  HomeViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var blurredImageView: UIImageView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var textView: UITextView!
	
	var index: Int!
	var infoItem: InfoItem!
	
	let inset: CGFloat = 4
	let scrollInset: CGFloat = 4
	
	override func viewDidLoad() {
		super.viewDidLoad()
		blurredImageView.image = infoItem.image
		imageView.image = infoItem.image
		textView.text = infoItem.body
		textView.contentInset.top = inset
		textView.scrollIndicatorInsets.top = inset + scrollInset
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		textView.contentOffset.y = -inset
	}
	
}

