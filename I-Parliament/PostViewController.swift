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
	weak var availableCell: AvailableItemTableViewCell?
	var delegate: DownloadDelegate?
	var downloadedCellIndexPath: IndexPath?
	
	var isDocument: Bool {
		if case .remote = postType {return false}
		return true
	}
	
	var webView = WKWebView()
	
	func shareTapped(_ sender: UIBarButtonItem) {
		guard case let .localFile(url) = postType else {return} //Weird way of saying: "Gimme a local file URL or get out"
		let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		activityController.popoverPresentationController?.barButtonItem = sender
		present(activityController, animated: true)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if #available(iOS 10.0, *), case .remote = postType {
			let configuration = WKWebViewConfiguration()
			configuration.dataDetectorTypes = [.phoneNumber, .link, .address, .calendarEvent]
			webView = WKWebView(frame: .zero, configuration: configuration)
		}
		
		automaticallyAdjustsScrollViewInsets = !isDocument
		webView.translatesAutoresizingMaskIntoConstraints = false //False enables AutoLayout
		webView.navigationDelegate = self
		view.addSubview(webView)
		
		//Bottom of the NavBar / top of view
		let topAnchor = isDocument ? topLayoutGuide.bottomAnchor : view.topAnchor
		//Top of TabBar / bottom of view
		let bottomAnchor = isDocument ? bottomLayoutGuide.topAnchor : view.bottomAnchor
		
		//Doing AutoLayout programatically (WKWebView can't be used in IB)
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: topAnchor),
			webView.bottomAnchor.constraint(equalTo: bottomAnchor),
			webView.leftAnchor.constraint(equalTo: view.leftAnchor),
			webView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
		
		switch postType {
		case let .remote(url), let .remoteFile(url):
			let request = URLRequest(url: url)
			webView.load(request)
		case let .localFile(url):
			webView.loadFileURL(url, allowingReadAccessTo: url)
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped(_:)))
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
		setRefreshBarButtonItem()
	}
	
	func refreshWebView() {
		webView.reload()
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		present(error)
		setRefreshBarButtonItem()
	}
	
	func setRefreshBarButtonItem() { //Sets the UIBarButtonItem to a refresh button
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWebView))
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if case let .remote(url) = postType, //If it's a blog post, then extract the blog post URL
			let requestURL = navigationAction.request.url, //Also extract the navigation request URL
			navigationAction.navigationType == .linkActivated, //If the navigation request was a link click (i.e. not a form)
			url.host != requestURL.host || url.path != requestURL.path { //And it wasn't equal to the blog post URL (ignoring the #fragment)
			
			decisionHandler(.cancel) //Then cancel the webView request
			UIApplication.shared.openURL(requestURL) //And instead open the requested URL in Safari
		} else {
			decisionHandler(.allow) //Otherwise allow the request
		}
	}
}

extension PostViewController {
	override var previewActionItems: [UIPreviewActionItem] {
		if case .remoteFile = postType,
			let cell = availableCell, let delegate = cell.delegate {
			
			return cell.isFileDownloaded ? [UIPreviewAction(title: "Delete", style: .destructive) { _, _ in
				delegate.deleteFile(for: cell)
			}] : [UIPreviewAction(title: "Download", style: .default) { _, _ in
				delegate.downloadFile(for: cell)
			}]
			
		} else if case let .localFile(url) = postType,
			let delegate = delegate,
			let indexPath = downloadedCellIndexPath {
			return [
				UIPreviewAction(title: "Share", style: .default) { _, _ in
					delegate.share(url)
				},
				UIPreviewAction(title: "Delete", style: .destructive) { _, _ in
					delegate.deleteItem(at: indexPath)
				}
			]
		} else {
			return []
		}
	}
}
