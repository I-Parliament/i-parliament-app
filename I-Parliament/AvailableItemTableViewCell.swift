//
//  AvailableItemTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

protocol AvailableItemDownloadDelegate {
	func urls(for item: AvailableItem) -> [URL]
	func download(item: AvailableItem)
}

class AvailableItemTableViewCell: UITableViewCell {
	
	var delegate: AvailableItemDownloadDelegate?
	
	var availableItem: AvailableItem! {
		didSet {
			textLabel?.text = availableItem.title
		}
	}
	
	let downloadButton = UIButton(type: .system)
	
    override func awakeFromNib() {
        super.awakeFromNib()
		indentationLevel = 1
		updateSaved()
		downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
		accessoryView = downloadButton
    }
	
	func downloadTapped() {
		delegate?.download(item: availableItem)
	}
	
	func updateSaved() {
		let image = delegate?.urls(for: availableItem).isEmpty == true ? #imageLiteral(resourceName: "Star") : #imageLiteral(resourceName: "Star Filled")
		UIView.transition(with: downloadButton, duration: animationDuration, options: .transitionCrossDissolve, animations: {
			self.downloadButton.setImage(image, for: .normal)
			}, completion: nil)
		downloadButton.sizeToFit()
	}

}
