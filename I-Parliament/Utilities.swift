//
//  Utilities.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 05/10/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
	func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
		let baseDescriptor = baseFont.fontDescriptor
		beginEditing()
		enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, length), options: []) { object, range, stop in
			if let font = object as? UIFont {
				// Instantiate a font with our base font's family, but with the current range's traits
				let traits = font.fontDescriptor.symbolicTraits
				guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else {return}
				let newFont = UIFont(descriptor: descriptor, size: preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize)
				self.removeAttribute(NSFontAttributeName, range: range)
				self.addAttribute(NSFontAttributeName, value: newFont, range: range)
			}
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
