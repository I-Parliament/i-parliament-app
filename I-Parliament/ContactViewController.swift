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
		
//		guard let filePath = Bundle.main.path(forResource: "contact", ofType: "html") else {return}
//		let fileURL = URL(fileURLWithPath: filePath)
//		let stringOptions: [String: Any] = [
//			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
//		]
//		let attributedString = try? NSAttributedString(url: fileURL, options: stringOptions, documentAttributes: nil)
//		
//		contactTextView.attributedText = attributedString
		contactTextView.text = "Hi"
    }

}
