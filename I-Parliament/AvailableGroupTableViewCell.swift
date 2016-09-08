//
//  AvailableGroupTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class AvailableGroupTableViewCell: UITableViewCell {
	
	var availableGroup: AvailableGroup! {
		didSet {
			textLabel?.text = availableGroup.title
		}
	}
	
	var disclosureView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		disclosureView = UIImageView(image: UIImage(named: "Disclosure"))
		disclosureView.tintColor = UIColor(white: 0.78, alpha: 1)
		accessoryView = disclosureView
    }
	
	func twirl(in tableView: UITableView) {
		availableGroup.expanded = !availableGroup.expanded
		guard let section = tableView.indexPath(for: self)?.section else {return}
		var newIndexPaths = [IndexPath]()
		for index in availableGroup.items.indices {
			newIndexPaths.append(IndexPath(row: index + 1, section: section))
		}
		
		updateDisclosureView(duration: 0.3)
		
		if availableGroup.expanded {
			tableView.insertRows(at: newIndexPaths, with: .automatic)
		} else {
			tableView.deleteRows(at: newIndexPaths, with: .automatic)
		}
	}
	
	func updateDisclosureView(duration: TimeInterval = 0) {
		disclosureView.rotate(to: availableGroup.expanded ? 90 : 0, duration: duration)
	}
	
}

extension UIView {
	///Rotates the view by specified degrees, animated if duration > 0
	func rotate(to degrees: CGFloat, duration: TimeInterval = 0) {
		let radians = degrees / 180 * CGFloat(M_PI)
		if duration > 0 {
			UIView.animate(withDuration: duration) {
				self.transform = CGAffineTransform(rotationAngle: radians)
			}
		} else {
			transform = CGAffineTransform(rotationAngle: radians)
		}
	}
}
