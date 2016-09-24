//
//  ImageLoader.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 11/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageLoader {
	
	static let shared = ImageLoader()
	
	private func image(for url: URL, completionHandler: @escaping (UIImage?) -> ()) {
		
		let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
			
			guard let data = data,
				let image = UIImage(data: data),
				error == nil
				else {
					completionHandler(nil)
					return
			}
			
			completionHandler(image)
		}
		
		downloadTask.resume()
	}
	
	func image(for id: Int, completionHandler: @escaping (UIImage?) -> ()) {
		
		guard let queryURL = URL(string: "http://blog.iparliament.in/wp-json/wp/v2/media?include=\(id)") else {
			completionHandler(nil)
			return
		}
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let dataTask = URLSession.shared.dataTask(with: queryURL) { data, response, error in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			guard let data = data,
				let body = JSON(data: data).array,
				error == nil && !body.isEmpty
				else {
					completionHandler(nil)
					return
			}
			
			guard let stringURL = body[0]["source_url"].string,
				let url = URL(string: stringURL)
				else {
					completionHandler(nil)
					return
			}
			
			self.image(for: url, completionHandler: completionHandler)
		}
		
		dataTask.resume()
	}
	
}

extension UIViewController {
	
	func present(_ error: Error,
	                  title: String = "Error",
	                  additionalActions: [UIAlertAction] = [],
	                  completion: (() -> ())? = nil) {
		let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alertController.addAction(okAction)
		
		for action in additionalActions {
			alertController.addAction(action)
		}
		
		present(alertController, animated: true, completion: completion)
	}
	
}
