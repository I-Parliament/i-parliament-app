//
//  ContactViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 01/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import WebKit

class ContactViewController: UIViewController {

	@IBOutlet weak var contactTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.tabBarItem.selectedImage = UIImage(named: "Contact Filled")
		
		let attributes: [String: UIFont] = [NSFontAttributeName: .systemFont(ofSize: 16)]
		let attributedText = NSMutableAttributedString(string: contactTextView.text, attributes: attributes)
		attributedText.registerEmails()
		contactTextView.attributedText = attributedText
    }

}

extension NSMutableAttributedString {
	func registerEmails() {
		guard let regex = try? NSRegularExpression(pattern: "\\S+@iparliment\\.in", options: []) else {return}
		let range = NSMakeRange(0, length)
		let matches = regex.matches(in: mutableString as String, options: [], range: range)
		matches.forEach {match in
			let string = attributedSubstring(from: match.range).string
			addAttribute(NSLinkAttributeName, value: "mailto:\(string)", range: match.range)
		}
	}
}
