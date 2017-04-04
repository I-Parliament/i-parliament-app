//
//  DownloadedItem.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import Foundation

struct DownloadedItem {
	let id: Int
	let title: String
	let url: URL
	
	init?(url: URL) { //Constructs a DownloadedItem given a local file URL (by extracting the parameters from the file name)
		let delimiter = "_"
		
		//eg. "/path/to/foo_7.pdf" -> "/path/to/foo_7" -> "foo_7" -> ["foo", "7"]
		let fileParts = url.deletingPathExtension().lastPathComponent.components(separatedBy: delimiter)
		
		guard fileParts.count > 1, //Makes sure that the file name is formatted correctly
			let lastPart = fileParts.last, //eg. "7"
			let id = Int(lastPart) else {return nil} //eg. "7" (String) -> 7 (Int)
		
		//If the file was in the format "foo_bar_7.pdf", it would become ["foo", "bar", "7"].
		//So this drops the "7" and joins the rest.
		//eg. ["foo", "bar", "7"] -> ["foo", "bar"] -> "foo_bar"
		let title = fileParts.dropLast().joined(separator: delimiter)
		
		self.id = id
		self.title = title
		self.url = url
	}
}
