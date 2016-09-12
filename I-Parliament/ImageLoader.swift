//
//  ImageLoader.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 11/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class ImageLoader {
	
	private init() {}
	static let shared = ImageLoader()
	
	private let cache = NSCache<AnyObject, AnyObject>()
	
	private func image(for stringURL: String, completionHandler: @escaping (UIImage) -> ()) {
		DispatchQueue.main.async {
			if let image = self.cache.object(forKey: stringURL as NSString) as? UIImage {
				completionHandler(image)
				return
			}
			
			guard let url = URL(string: stringURL) else {return}
			
			let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
				guard let data = data,
					let image = UIImage(data: data),
					error == nil
					else {return}
				self.cache.setObject(image, forKey: stringURL as NSString)
				completionHandler(image)
			}
			downloadTask.resume()
		}
	}
	
	func image(for id: Int?, completionHandler: @escaping (UIImage) -> ()) {
		
		guard let id = id, id > 0 else {return}
		
		if let url = cache.object(forKey: id as NSNumber) as? String {
			image(for: url, completionHandler: completionHandler)
			return
		}
		
		guard let queryURL = URL(string: "http://blog.iparliament.in/wp-json/wp/v2/media?include=\(id)") else {return}
		
		let dataTask = URLSession.shared.dataTask(with: queryURL) { data, response, error in
			guard let data = data,
				let jsonData = (try? JSONSerialization.jsonObject(with: data, options: [])),
				let body = jsonData as? [JSON],
				error == nil && !body.isEmpty
				else {return}
			
			guard let url = body[0]["source_url"] as? String else {return}
			self.cache.setObject(url as NSString, forKey: id as NSNumber)
			
			self.image(for: url, completionHandler: completionHandler)
		}
		
		dataTask.resume()
	}
	
//	func image(for id: Int, completionHandler: @escaping (UIImage?) -> ()) {
//		url(for: id) { stringURL in
//			guard let stringURL = stringURL else {return}
//			self.image(for: stringURL, completionHandler: completionHandler)
//		}
//	}
}
