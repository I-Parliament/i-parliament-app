//
//  BlogTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 13/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class BlogTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	
	@IBOutlet weak var thumbnailView: UIImageView?
	
	@IBOutlet weak var thumbnailWidth: NSLayoutConstraint!
	@IBOutlet weak var thumbnailPadding: NSLayoutConstraint!
	
	var thumbnailWidthConstant: CGFloat!
	var thumbnailPaddingConstant: CGFloat!
	
	func setThumbnail(_ image: UIImage) {
		DispatchQueue.main.async {
			self.thumbnailView?.image = image
			self.thumbnailPadding.constant = self.thumbnailPaddingConstant
			self.thumbnailWidth.constant = self.thumbnailWidthConstant
		}
	}
	
	override func awakeFromNib() {
		thumbnailWidthConstant = thumbnailWidth.constant
		thumbnailWidth.constant = 0
		thumbnailPaddingConstant = thumbnailPadding.constant
		thumbnailPadding.constant = 0
	}
	
}