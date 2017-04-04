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
	
	var thumbnail: UIImage? {
		get { return thumbnailView?.image }
		set {
			DispatchQueue.main.async {
				self.thumbnailView?.image = newValue
				let constantMultiplier: CGFloat = newValue == nil ? 0 : 1
				self.thumbnailPadding.constant = self.thumbnailPaddingConstant * constantMultiplier
				self.thumbnailWidth.constant = self.thumbnailWidthConstant * constantMultiplier
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		thumbnailWidthConstant = thumbnailWidth.constant
		thumbnailPaddingConstant = thumbnailPadding.constant
		thumbnail = nil
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		thumbnail = nil
	}
	
}
