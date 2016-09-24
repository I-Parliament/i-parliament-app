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
	var url: URL
	var date: Date?
	var mediaID: Int
	var categories: [Int]
	var excerpt: String
	
	var attributedString: NSAttributedString {
		return excerpt.htmlAttributed ?? NSAttributedString(string: excerpt)
	}
	
	init(title: String, url: URL, date: Date?, mediaID: Int?, excerpt: String, categories: [Int]?) {
		self.title = title
		self.date = date
		self.mediaID = mediaID ?? 0
		self.url = url
		self.excerpt = excerpt
		self.categories = categories ?? []
	}
}

func ==(lhs: BlogItem, rhs: BlogItem) -> Bool {
	return lhs.title == rhs.title
		&& lhs.date == rhs.date
		&& lhs.mediaID == rhs.mediaID
		&& lhs.url == rhs.url
		&& lhs.categories == rhs.categories
}
