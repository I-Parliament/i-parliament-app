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
		let attributedText: NSMutableAttributedString = contactTextView.attributedText.mutableCopy() as! NSMutableAttributedString
		attributedText.registerEmails()
		contactTextView.attributedText = attributedText
		contactTextView.setContentOffset(CGPoint(x: 0, y: -1000), animated: false)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		contactTextView.scrollIndicatorInsets.bottom = 0
		contactTextView.flashScrollIndicators()
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
	
	func add(attribute: String, to substring: String, index: Int = 0) {
		
	}
}
