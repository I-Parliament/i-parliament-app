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
	case remoteFile(URL)
	case localFile(URL)
}

class PostViewController: UIViewController {
	
	var postType: PostType = .none
	
	lazy var isDocument: Bool = {
		if case .remote = self.postType {
			return false
		}
		return true
	}()
	
	let webView = WKWebView()
	
	func shareTapped() {
		guard case let .localFile(url) = postType else {return} //Weird way of saying: "Gimme a local file URL or get out"
		let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		automaticallyAdjustsScrollViewInsets = !isDocument
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.navigationDelegate = self
		view.addSubview(webView)
		
		let topAnchor = isDocument ? topLayoutGuide.bottomAnchor : view.topAnchor
		let bottomAnchor = isDocument ? bottomLayoutGuide.topAnchor : view.bottomAnchor
		
		webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		
		switch postType {
		case .remote(let url), .remoteFile(let url):
			let request = URLRequest(url: url)
			webView.load(request)
		case .localFile(let url):
			webView.loadFileURL(url, allowingReadAccessTo: url)
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		case .none:
			break
		}
	}
}

extension PostViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		if case .localFile = postType {return}
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activityIndicator.startAnimating()
		let activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
		navigationItem.rightBarButtonItem = activityBarButtonItem
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		if case .localFile = postType {return}
		navigationItem.rightBarButtonItem = nil
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		present(error) //TODO: Figure out why this is not called
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if case let .remote(url) = postType {
			let whitelist = [url, URL(string: "http://blog.iparliament.in/wp-comments-post.php")!]
			if let requestURL = navigationAction.request.url, !whitelist.contains {$0.host == url.host && $0.path == url.path} {
				decisionHandler(.cancel)
				UIApplication.shared.openURL(requestURL)
				return
			}
		}
		decisionHandler(.allow)
	}
}
