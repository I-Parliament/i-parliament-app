//
//  BlogItem.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 11/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class BlogItem: Equatable { //Pass by reference
	var title: String
	var content: String
	var url: URL
	var date: Date?
	var mediaID: Int?
	
	init(title: String, content: String, url: URL, date: Date?, mediaID: Int?) {
		self.title = title
		self.content = content
		self.date = date
		self.mediaID = mediaID
		self.url = url
	}
}

func ==(lhs: BlogItem, rhs: BlogItem) -> Bool {
	return lhs.title == rhs.title
		&& lhs.content == rhs.content
		&& lhs.date == rhs.date
		&& lhs.mediaID == rhs.mediaID
		&& lhs.url == rhs.url
}
