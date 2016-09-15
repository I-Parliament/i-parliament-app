//
//  PostViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 12/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import WebKit

enum PostType {
	case none
	case remote(URL)
	case local(URL)
	case html(String)
}

class PostViewController: UIViewController {
	
	var postType: PostType = .none
	
	let webView = WKWebView()
	
	@IBAction func shareTapped(_ sender: AnyObject) {
		var activityItems = [Any]()
		switch postType {
		case .local(let url):
			activityItems = [url]
		case .remote(let url):
			activityItems = [url] //TODO: Use PDF instead of the URL
		default:
			break
		}
		let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		automaticallyAdjustsScrollViewInsets = false
		view.addSubview(webView)
		
		var isHTML = false
		
		switch postType {
		case .remote(let url):
			let request = URLRequest(url: url)
			webView.load(request)
		case .local(let url):
			webView.loadFileURL(url, allowingReadAccessTo: url)
		case .html(let string):
			let htmlString = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><link rel=\"stylesheet\" href=\"stylesheet.css\"><body>\(string)</body>"
			webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
			isHTML = true
		case .none:
			break
		}
		
		if isHTML {
			navigationItem.rightBarButtonItem = nil
		}
		
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		webView.frame = view.frame
		webView.frame.origin.y = topLayoutGuide.length
		webView.frame.size.height -= (topLayoutGuide.length + bottomLayoutGuide.length)
	}

}
