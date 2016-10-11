//
//  AvailableItemTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

protocol DownloadDelegate {
	func urls(for item: AvailableItem?) -> [URL]
	func downloadFile(for cell: AvailableItemTableViewCell)
	func deleteFile(for cell: AvailableItemTableViewCell)
	func deleteItem(at indexPath: IndexPath)
	func share(_ url: URL)
}

class AvailableItemTableViewCell: UITableViewCell {
	
	var delegate: DownloadDelegate?
	
	var isFileDownloaded: Bool {
		return delegate?.urls(for: availableItem).isEmpty == false
	}
	
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
		let updateFunction = isFileDownloaded ? delegate?.deleteFile : delegate?.downloadFile
		updateFunction?(self)
	}
	
	func updateSaved() {
		let image = isFileDownloaded ? #imageLiteral(resourceName: "Downloaded") : #imageLiteral(resourceName: "Download")
		downloadButton.setImage(image, for: .normal)
		accessoryView = downloadButton
		downloadButton.sizeToFit()
	}

}
