//
//  AvailableItemTableViewCell.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class AvailableItemTableViewCell: UITableViewCell {
	
	var availableItem: AvailableItem! {
		didSet {
			textLabel?.text = availableItem.title
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		indentationLevel = 1
    }

}
