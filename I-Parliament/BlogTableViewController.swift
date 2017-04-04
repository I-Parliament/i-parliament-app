//
//  BlogTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 10/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import SwiftyJSON

let apiEndpoint = "http://blog.iparliament.in/wp-json/wp/v2/"

class BlogTableViewController: UITableViewController, ChildViewController {
	
	var segmentedControl: UISegmentedControl!
	var containerViewController: ContainerViewController!
	
	var items: [BlogItem] = []
	
	let images = NSCache<NSNumber, UIImage>() //More optimised than a Dictionary
	
	var dataTask: URLSessionDataTask?
	var nextPage = 1
	var shouldLoadNext = true
	
	func segmentChanged(_ sender: AnyObject) {
		tableView.reloadData() /* //Comment this line to enable the animation (Do the same in DownloadsTableViewController)
		let animation: UITableViewRowAnimation = iParliamentSelected ? .right : .left
		tableView.reloadSections([0], with: animation) // */
	}
	
	var iParliamentSelected: Bool {
		return segmentedControl?.selectedSegmentIndex == 0
	}
	
	let iParliamentID = 1
	var iParliamentItems: [BlogItem] {
		return items.filter {$0.categories.contains(iParliamentID)}
	}
	
	let democracyClubID = 6
	var democracyClubItems: [BlogItem] {
		return items.filter {$0.categories.contains(democracyClubID)}
	}
	
	var relevantItems: [BlogItem] {
		return iParliamentSelected ? iParliamentItems : democracyClubItems
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupRefreshControl()
		downloadContent()
    }
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(downloadContent), for: .valueChanged)
	}
	
	func downloadContent(fetchNext: Bool = false) {
		guard !fetchNext || shouldLoadNext else {return}
		nextPage = fetchNext ? nextPage + 1 : 1
		guard let url = URL(string: "\(apiEndpoint)posts?page=\(nextPage)&per_page=15") else {return}
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
				let body = JSON(data: data).array else {return}
			
			//If fetchNext is true then add onto the existing array, otherwise start fresh
			let startItems: [BlogItem] = fetchNext ? self.items : []
			//flatMap returns all BlogItems that were successfully initialised from the JSON
			self.items = startItems + body.flatMap(BlogItem.init)
		}
		dataTask?.resume()
	}
	
    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relevantItems.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let blogItem = relevantItems[indexPath.row]
		let mediaID = blogItem.mediaID
		
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogImageCell", for: indexPath) as! BlogTableViewCell
		
		if mediaID > 0 { //If the cell should have an image
			if let image = images.object(forKey: mediaID as NSNumber) { //If the image exists, set it
				cell.thumbnail = image
			} else { //If the image doesn't exist, download it
				ImageLoader.shared.image(for: mediaID) { image in
					guard let image = image else {return}
					self.images.setObject(image, forKey: mediaID as NSNumber)
					cell.thumbnail = image
				}
			}
		} else { //If the cell should not have an image, remove the old one if the cell is reused
			cell.thumbnail = nil
		}
		
		cell.titleLabel?.text = blogItem.title
		if let dateString = blogItem.dateString {
			cell.dateLabel?.text = dateString
		}
		
		let mutableAttributedString = blogItem.attributedString.mutableCopy() as! NSMutableAttributedString
		mutableAttributedString.setBaseFont(.systemFont(ofSize: 16))
		
		let stringRange = NSMakeRange(0, mutableAttributedString.length)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: stringRange)
		
		cell.contentLabel.attributedText = mutableAttributedString
		
        return cell
    }
	
	//http://stackoverflow.com/a/37760230/3769927
	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		
		//Change 10.0 to adjust the distance from bottom
		if maximumOffset - currentOffset <= 10 {
			downloadContent(fetchNext: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
    //MARK: - Navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let senderRow: IndexPath?
		if let cell = sender as? UITableViewCell {
			senderRow = tableView.indexPath(for: cell)
		} else {
			senderRow = nil
		}
		guard let postController = segue.destination as? PostViewController,
			let indexPath = tableView.indexPathForSelectedRow ?? senderRow
			else {return}
		
		let item = relevantItems[indexPath.row]
		postController.postType = .remote(item.url)
		postController.title = item.title
    }

}
