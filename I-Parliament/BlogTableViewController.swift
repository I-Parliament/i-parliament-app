//
//  BlogTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 10/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

let apiEndpoint = "http://blog.iparliament.in/wp-json/wp/v2/"

class BlogTableViewController: UITableViewController, ChildViewController {
	
	var segmentedControl: UISegmentedControl!
	
	var items = [BlogItem]()
	let images = NSCache<NSNumber, UIImage>() //More optimised than a Dictionary
	
	var nextPage: Int {
		let tenths = Double(items.count) / 10
		let nearestTen = 10 * Int(floor(tenths))
		return nearestTen + 1 //As we need the *next* page
	}
	
	var dataTask: URLSessionDataTask?
	var dateFormatter = DateFormatter()
	let readableFormatter = DateFormatter()
	
	func segmentChanged(_ sender: AnyObject) {
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
		
		readableFormatter.dateStyle = .long
		
		setupRefreshControl()
		downloadContent()
    }
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}
	
	func refresh() {
		downloadContent()
	}
	
	func downloadContent(page: Int = 1) {
		guard let url = URL(string: "\(apiEndpoint)posts?page=\(page)") else {return}
		dataTask?.cancel()
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
			defer {
				DispatchQueue.main.async {
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
					self.refreshControl?.endRefreshing()
					self.tableView.reloadData()
				}
			}
			
			if let error = error {
				if error.localizedDescription == "cancelled" {return}
				self.present(error)
				return
			}
			
			guard let data = data,
				let jsonData = (try? JSONSerialization.jsonObject(with: data, options: [])),
				let body = jsonData as? [JSON],
				body.count > 0
				else {return}
			self.items = []
			for item in body {
				guard let title = item["title"] as? JSON,
					let renderedTitle = title["rendered"] as? String,
					
					let content = item["content"] as? JSON,
					let renderedContent = content["rendered"] as? String,
					
					let stringURL = item["link"] as? String,
					let url = URL(string: stringURL)
					else {return} //These are necessary
				
				var date: Date?
				
				if let dateString = item["date_gmt"] as? String {
					date = self.dateFormatter.date(from: dateString)
				}
				
				let mediaID = item["featured_media"] as? Int
				
				var renderedExcerpt: String?
				
				if let excerpt = item["excerpt"] as? JSON {
					renderedExcerpt = excerpt["rendered"] as? String
				}
				
				let blogItem = BlogItem(title: renderedTitle,
				                        content: renderedContent,
				                        url: url,
				                        date: date,
				                        mediaID: mediaID,
				                        excerpt: renderedExcerpt)
				
				self.items.append(blogItem)
			}
		}
		dataTask?.resume()
	}
	
    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let blogItem = items[indexPath.row]
		let mediaID = blogItem.mediaID ?? 0
		
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogImageCell", for: indexPath) as! BlogTableViewCell
		
		let image = images.object(forKey: mediaID as NSNumber)
		if mediaID > 0 && image == nil { //If 0 then there is no media for the image
			DataLoader.shared.image(for: mediaID) { image in
				guard let image = image else {return}
				self.images.setObject(image, forKey: mediaID as NSNumber)
				cell.setThumbnail(image)
			}
		}
		
		cell.titleLabel?.text = blogItem.title
		if let date = blogItem.date {
			cell.dateLabel?.text = readableFormatter.string(from: date)
		}
		
		let string: NSAttributedString
		
		if let excerpt = blogItem.excerpt {
			string = excerpt.htmlAttributed ?? NSAttributedString(string: excerpt)
		} else {
			let content = blogItem.content
			string = content.htmlAttributed ?? NSAttributedString(string: content)
		}
		
		let mutableAttributedString = string.mutableCopy() as! NSMutableAttributedString
		mutableAttributedString.setBaseFont(baseFont: .systemFont(ofSize: 16))
		
		let stringRange = NSMakeRange(0, mutableAttributedString.length)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: stringRange)
		
		cell.contentLabel.attributedText = mutableAttributedString
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
    //MARK: - Navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let postController = segue.destination as? PostViewController,
			let selected = tableView.indexPathForSelectedRow
			else {return}
		
		let item = items[selected.row]
		postController.postType = .html(item.content)
		postController.title = item.title
    }

}
