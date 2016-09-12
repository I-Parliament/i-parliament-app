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

class BlogTableViewController: UITableViewController {
	
	var items = [BlogItem]()
	
	var dataTask: URLSessionDataTask?
	var dateFormatter = DateFormatter()
	let readableFormatter = DateFormatter()
	
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
		refreshControl?.addTarget(self, action: #selector(downloadContent), for: .valueChanged)
	}
	
	func downloadContent() {
		guard let url = URL(string: "\(apiEndpoint)posts") else {return}
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
			guard let data = data,
				let jsonData = (try? JSONSerialization.jsonObject(with: data, options: [])),
				let body = jsonData as? [JSON],
				error == nil
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
				
				let blogItem = BlogItem(title: renderedTitle,
				                        content: renderedContent,
				                        url: url,
				                        date: date,
				                        mediaID: mediaID)
				
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath)
		let blogItem = items[indexPath.row]
		ImageLoader.shared.image(for: blogItem.mediaID) { image in
			DispatchQueue.main.async {
				cell.imageView?.image = image
				cell.setNeedsLayout()
			}
		}
		cell.textLabel?.text = blogItem.title
		if let date = blogItem.date {
			cell.detailTextLabel?.text = readableFormatter.string(from: date)
		}
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
		postController.postType = .html(string: item.content)
		postController.title = item.title
    }

}