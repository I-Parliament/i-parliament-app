//
//  ContainerViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 13/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

protocol ChildViewController {
	func segmentChanged(_ sender: AnyObject)
	var segmentedControl: UISegmentedControl! {get set}
	var tableView: UITableView! {get set}
}

class ContainerViewController: UIViewController {
	
	var delegate: ChildViewController?
	
	var imageView: UIImageView?
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	let topOffset: CGFloat = 37
	let bottomOffset = -49 - 1 / UIScreen.main.scale
	
	@IBAction func segmentChanged(_ sender: AnyObject) {
		delegate?.segmentChanged(sender)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		setHairline(hidden: false)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setHairline(hidden: true)
	}
	
	private func setHairline(hidden: Bool) {
		guard let navigationBar = navigationController?.navigationBar else {return}
		for view in navigationBar.subviews {
			for subview in view.subviews where subview is UIImageView {
				subview.isHidden = hidden
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		delegate = segue.destination as? ChildViewController
		
		delegate?.tableView.contentInset.top = topOffset
		delegate?.tableView.scrollIndicatorInsets.top = topOffset
		delegate?.tableView.contentInset.bottom = bottomOffset
		delegate?.tableView.scrollIndicatorInsets.bottom = bottomOffset
		
		delegate?.segmentedControl = segmentedControl
	}
	
}
