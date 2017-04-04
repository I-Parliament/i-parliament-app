//
//  AvailableItem.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import Foundation
import SwiftyJSON

//Not a struct as it needs to be passed by reference
class AvailableItem {
	let id: Int
	let title: String
	let url: URL
	let groupName: String
	
	init?(json: JSON) {
		guard let stringURL = json["source_url"].string,
			let url = URL(string: stringURL),
			let title = json["title"]["rendered"].string,
			let id = json["id"].int,
			let itemDescription = json["description"].string
			else {return nil}
		
		let splitDescription = itemDescription.components(separatedBy: "Group: ")
		guard splitDescription.count == 2 else {return nil} // Don't display the item unless it has a group
		
		self.id = id
		self.title = title.htmlDecoded
		self.url = url
		self.groupName = splitDescription[1].htmlDecoded
	}
}
