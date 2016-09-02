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

	var webView = WKWebView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.tabBarItem.selectedImage = UIImage(named: "Contact Filled")
		
		guard let filePath = Bundle.main.path(forResource: "contact", ofType: "html") else {return}
		let fileURL = URL(fileURLWithPath: filePath)
		webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		webView.frame = view.frame
		webView.scrollView.contentInset.bottom -= 108
		view.addSubview(webView)
	}

}
