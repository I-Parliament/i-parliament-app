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
	
	var hairlineView: UIImageView? {
		return navigationController?.navigationBar.subviews.first?.subviews.first as? UIImageView
	}
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBAction func segmentChanged(_ sender: AnyObject) {
		delegate?.segmentChanged(sender)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.view.backgroundColor = .white
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		hairlineView?.isHidden = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hairlineView?.isHidden = true
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		delegate = segue.destination as? ChildViewController
		
		let insets = UIEdgeInsets(top: 37, left: 0, bottom: -49 - 1 / UIScreen.main.scale, right: 0)
		delegate?.tableView.contentInset = insets
		delegate?.tableView.scrollIndicatorInsets = insets
		
		delegate?.segmentedControl = segmentedControl
	}
	
}
