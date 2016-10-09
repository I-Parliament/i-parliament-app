//
//  Utilities.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 05/10/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import SwiftyJSON

extension NSMutableAttributedString {
	func setBaseFont(_ baseFont: UIFont) {
		let baseDescriptor = baseFont.fontDescriptor
		beginEditing()
		enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, length)) { object, range, _ in
			guard let font = object as? UIFont else {return}
			let traits = font.fontDescriptor.symbolicTraits
			//Creates a UIFontDescriptor with the base font, preserving traits of the current font (bold, italics, etc.)
			guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else {return}
			//Converts the fontDescriptor into a UIFont
			let newFont = UIFont(descriptor: descriptor, size: baseDescriptor.pointSize)
			removeAttribute(NSFontAttributeName, range: range)
			addAttribute(NSFontAttributeName, value: newFont, range: range)
		}
		endEditing()
	}
}

extension String {
	var htmlAttributed: NSAttributedString? {
		guard let encodedData = data(using: .utf8) else {return nil}
		let attributeOptions: [String: Any] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
		]
		return try? NSAttributedString(data: encodedData, options: attributeOptions, documentAttributes: nil)
	}
	
	var htmlDecoded: String {
		guard contains("&") else {return self}
		return htmlAttributed?.string ?? self
	}
	
}

extension UIViewController {
	func present(_ error: Error,
	             animated: Bool = true,
	             title: String = "Error",
	             additionalActions: [UIAlertAction]? = nil,
	             completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		alertController.addAction(okAction)
		additionalActions?.forEach {alertController.addAction($0)}
		present(alertController, animated: animated, completion: completion)
	}
}

struct ImageLoader {
	static let shared = ImageLoader()
	
	private func image(for url: URL, completionHandler: @escaping (UIImage?) -> ()) {
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data,
				let image = UIImage(data: data),
				error == nil else {
					completionHandler(nil)
					return
			}
			
			completionHandler(image)
		}.resume()
	}
	
	func image(for id: Int, completionHandler: @escaping (UIImage?) -> ()) {
		
		guard let queryURL = URL(string: "\(apiEndpoint)media?include=\(id)") else {
			completionHandler(nil)
			return
		}
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		URLSession.shared.dataTask(with: queryURL) { data, response, error in
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			
			guard let data = data,
				let stringURL = JSON(data: data)[0]["source_url"].string,
				let url = URL(string: stringURL),
				error == nil else {
					completionHandler(nil)
					return
			}
			
			self.image(for: url, completionHandler: completionHandler)
		}.resume()
	}
}
