//
//  AvailableGroupTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

let animationDuration: TimeInterval = 0.3

class AvailableGroupTableViewCell: UITableViewCell {
	
	var availableGroup: AvailableGroup! {
		didSet {
			textLabel?.text = availableGroup.title
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		let disclosureView = UIImageView(image: #imageLiteral(resourceName: "Disclosure"))
		disclosureView.tintColor = UIColor(white: 0.78, alpha: 1)
		accessoryView = disclosureView
    }
	
	func twirl(in tableView: UITableView) {
		guard let section = tableView.indexPath(for: self)?.section else {return}
		
		availableGroup.expanded = !availableGroup.expanded
		
		updateDisclosureView(duration: animationDuration)
		
		var newIndexPaths = [IndexPath]()
		for index in availableGroup.items.indices {
			let newIndexPath = IndexPath(row: index + 1, section: section)
			newIndexPaths.append(newIndexPath)
		}
		
		let updateFunction = availableGroup.expanded ? tableView.insertRows : tableView.deleteRows
		updateFunction(newIndexPaths, .automatic)
	}
	
	/**
	Rotates the disclosure view depending on whether `availableGroup` is expanded or not.
	- parameter duration: If greater than 0, the rotation is animated. The default is 0.
	*/
	func updateDisclosureView(duration: TimeInterval = 0) {
		let decimalDegrees: CGFloat = availableGroup.expanded ? 0.5 : 0
		let radians = decimalDegrees * CGFloat(M_PI)
		UIView.animate(withDuration: duration) {
			self.accessoryView?.transform = CGAffineTransform(rotationAngle: radians)
		}
	}
	
}
