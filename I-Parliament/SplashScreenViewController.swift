//
//  SplashScreenViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 20/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

	@IBOutlet weak var ribbonImageView: UIImageView!
	@IBOutlet weak var noRibbonImageView: UIImageView!
	
	let maskView = UIView()
	
	var tabBarControllerIndex = 0
	weak var rootTabBarController: UITabBarController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		maskView.frame = view.frame
		maskView.backgroundColor = .white
		view.insertSubview(maskView, aboveSubview: ribbonImageView)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 1, animations: {
			self.maskView.frame.origin.x += self.view.frame.width
		}, completion: { _ in
			self.performSegue(withIdentifier: "showTabBarController", sender: nil)
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		rootTabBarController = segue.destination as? UITabBarController
		rootTabBarController?.selectedIndex = tabBarControllerIndex
	}

}
