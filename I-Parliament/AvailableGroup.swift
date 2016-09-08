//
//  AvailableGroup.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import Foundation

class AvailableGroup { //Not a struct as it needs to be passed by reference
	var title: String
	var items: [AvailableItem]
	var expanded: Bool = false
	
	init(title: String, items: [AvailableItem]) {
		self.title = title
		self.items = items
	}
}
