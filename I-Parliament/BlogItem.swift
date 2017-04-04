//
//  BlogItem.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 11/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import SwiftyJSON

class BlogItem: Equatable { //Pass by reference
	let title: String
	let url: URL
	let mediaID: Int
	let categories: [Int]
	let excerpt: String
	fileprivate let date: Date?
	
	private static let dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		return dateFormatter
	}()
	
	private static let readableFormatter: DateFormatter = {
		let readableFormatter = DateFormatter()
		readableFormatter.dateStyle = .short
		return readableFormatter
	}()
	
	var attributedString: NSAttributedString {
		return excerpt.htmlAttributed ?? NSAttributedString(string: excerpt)
	}
	
	var dateString: String? {
		guard let date = date else {return nil}
		return BlogItem.readableFormatter.string(from: date)
	}
	
	init?(json: JSON) {
		guard let title = json["title"]["rendered"].string,
			let excerpt = json["excerpt"]["rendered"].string,
			let stringURL = json["link"].string,
			let url = URL(string: stringURL + "#main") //We want to directly jump to #main on the webpage
			else {return nil}
		
		self.title = title
		self.url = url
		self.excerpt = excerpt
		
		date = BlogItem.dateFormatter.date(from: json["date_gmt"].string ?? "")
		mediaID = json["featured_media"].int ?? 0
		categories = json["categories"].arrayObject as? [Int] ?? []
	}
}

func ==(lhs: BlogItem, rhs: BlogItem) -> Bool {
	return lhs.title == rhs.title
		&& lhs.date == rhs.date
		&& lhs.mediaID == rhs.mediaID
		&& lhs.url == rhs.url
		&& lhs.categories == rhs.categories
}
