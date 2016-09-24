//
//  AvailableItem.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import Foundation

//Not a struct as it needs to be passed by reference
class AvailableItem {
	var id: Int
	var title: String
	var url: URL
	
	init(id: Int, title: String, url: URL) {
		self.id = id
		self.title = title
		self.url = url
	}
}
