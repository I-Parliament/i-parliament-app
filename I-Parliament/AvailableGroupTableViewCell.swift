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
			let items = availableGroup.items.count
			let detailString = "\(items) item\(items == 1 ? "" : "s")"
			detailTextLabel?.text = detailString
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		accessoryView = UIImageView(image: #imageLiteral(resourceName: "Disclosure"))
		accessoryView?.tintColor = UIColor(white: 0.78, alpha: 1)
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
		let radians: CGFloat = availableGroup.expanded ? .pi / 2 : 0
		UIView.animate(withDuration: duration) {
			self.accessoryView?.transform = CGAffineTransform(rotationAngle: radians)
		}
	}
	
}
