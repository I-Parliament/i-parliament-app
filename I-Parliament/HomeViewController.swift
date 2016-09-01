//
//  HomeViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.tabBarItem.selectedImage = UIImage(named: "Home Filled")
	}

}

