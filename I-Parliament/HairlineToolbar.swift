//
//  HairlineToolbar.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 13/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HairlineToolbar: UIToolbar {
	
	let height: CGFloat = 44
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//Creates the thinnest view for that device (1px, 0.5px, or 0.33px)
		let hairlineView = UIView(frame: frame)
		hairlineView.frame.size.height = 1 / UIScreen.main.scale
		hairlineView.frame.origin.y = height - hairlineView.frame.height
		hairlineView.layer.backgroundColor = UIColor(white: 0, alpha: 0.25).cgColor
		addSubview(hairlineView)
	}
	
}
