//
//  DownloadsTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit
import SwiftyJSON

class DownloadsTableViewController: UITableViewController, ChildViewController {
	
	var segmentedControl: UISegmentedControl!
	var containerViewController: ContainerViewController!
	
	var availableGroups: [AvailableGroup] = []
	var dataTask: URLSessionDataTask?
	
	var availableSelected: Bool {
		return segmentedControl?.selectedSegmentIndex == 0
	}
	
	var downloadedItems: [DownloadedItem] = []
	
	func segmentChanged(_ sender: AnyObject) {
		isEditing = false
		containerViewController.navigationItem.leftBarButtonItem = availableSelected ? nil : editButtonItem
		
		tableView.reloadData() /* //Comment this line to enable the animation (Do the same in BlogTableViewController)
		tableView.beginUpdates()
		tableView.reloadSections([0], with: availableSelected ? .right : .left)
		if availableGroups.count > 1 { //We need to add or remove the extra section
			let indexSet = IndexSet(integersIn: 1..<availableGroups.count)
			let sectionFunction = availableSelected ? tableView.insertSections : tableView.deleteSections
			sectionFunction(indexSet, .left)
		}
		tableView.endUpdates() // */
		
		if availableSelected {
			setupRefreshControl()
		} else {
			refreshControl?.endRefreshing()
			refreshControl = nil
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupRefreshControl()
		refreshData()
	}
	
	//MARK: - Helper Functions
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}
	
	func refreshData() {
		fetchAvailable()
		fetchDownloaded()
	}
	
	func fetchAvailable() {
		guard let url = URL(string: "\(apiEndpoint)media?mime_type=application%2Fpdf&per_page=100") else {return}
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
			
			self.availableGroups = []
			
			for item in body {
				guard let availableItem = AvailableItem(json: item) else {continue}
				
				// If the item's group already exists
				if let index = self.availableGroups.index(where: {$0.title == availableItem.groupName}) {
					// Append the item to that group
					self.availableGroups[index].items.append(availableItem)
				} else {
					// Otherwise it's a new group, so create it and add the item to it
					let availableGroup = AvailableGroup(title: availableItem.groupName, items: [availableItem])
					self.availableGroups.append(availableGroup)
				}
			}
		}
		dataTask?.resume()
	}
	
	//MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		//Always at least one section to make transitioning easier as handling a 0 case in segmentChanged(_:) would be harder
		let availableSections = max(availableGroups.count, 1)
		return availableSelected ? availableSections : 1
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if availableSelected {
			if availableGroups.isEmpty {
				return 0 //So that if numberOfSections returned 1 section (which should be blank) this returns 0 rows
			}
			return (availableGroups[section].expanded ? availableGroups[section].items.count : 0) + 1 //One extra row for group name
		}
		return downloadedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !availableSelected { //Downloaded item
			let cell = tableView.dequeueReusableCell(withIdentifier: "downloadedCell", for: indexPath)
			cell.textLabel?.text = downloadedItems[indexPath.row].title
			return cell //Doesn't fall through
		}
		let rowGroup = availableGroups[indexPath.section]
		if indexPath.row == 0 { //Available Group
			let cell = tableView.dequeueReusableCell(withIdentifier: "availableGroupCell", for: indexPath) as! AvailableGroupTableViewCell
			cell.availableGroup = rowGroup
			cell.updateDisclosureView() //Corrects the disclosure view orientation when returning from the "Downloaded" table
			return cell
		} else { //Available Item
			let cell = tableView.dequeueReusableCell(withIdentifier: "availableCell", for: indexPath) as! AvailableItemTableViewCell
			cell.availableItem = rowGroup.items[indexPath.row - 1]
			cell.delegate = self
			cell.updateSaved()
			return cell
		}
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let cell = tableView.cellForRow(at: indexPath) as? AvailableGroupTableViewCell else {return}
		UIView.animate(withDuration: animationDuration) {
			DispatchQueue.main.async {
				cell.twirl(in: tableView)
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return !availableSelected
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		deleteItem(at: indexPath)
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
		
		if availableSelected {
			let group = availableGroups[indexPath.section]
			let item = group.items[indexPath.row - 1]
			postController.postType = .remoteFile(item.url)
			postController.title = item.title
			postController.availableCell = sender as? AvailableItemTableViewCell
		} else {
			let item = downloadedItems[indexPath.row]
			postController.postType = .localFile(item.url)
			postController.downloadedCellIndexPath = senderRow
			postController.delegate = self
			postController.title = item.title
		}
	}
}

//MARK: - File and download management

extension DownloadsTableViewController: DownloadDelegate {
	
	//The file may have multiple URLs (because of an undetected bug), so fetch all instances of the file by filtering by id
	func urls(for item: AvailableItem? = nil) -> [URL] {
		let fileManager = FileManager.default
		guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
			let fileURLs = try? fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
			else {return []}
		if let id = item?.id {
			return fileURLs.filter { id == DownloadedItem(url: $0)?.id }
		} else {
			return fileURLs
		}
	}
	
	func fetchDownloaded() {
		downloadedItems = []
		let fileURLs = urls()
		for fileURL in fileURLs {
			guard let item = DownloadedItem(url: fileURL) else {continue}
			downloadedItems.append(item)
		}
	}
	
	//Downloads the file associated with the cell's item and saves it as "filename_id.pdf" (eg. "foo_7.pdf")
	func downloadFile(for cell: AvailableItemTableViewCell) {
		let fileManager = FileManager.default
		let item = cell.availableItem!
		guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {return}
		
		let saveURL = documents.appendingPathComponent("\(item.title)_\(item.id).pdf")
		let downloadTask = URLSession.shared.downloadTask(with: item.url) { url, response, error in
			guard let url = url, error == nil else {return}
			
			try? fileManager.copyItem(at: url, to: saveURL)
			
			self.fetchDownloaded()
			DispatchQueue.main.async {
				cell.updateSaved()
			}
		}
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		cell.accessoryView = activityIndicator
		activityIndicator.startAnimating()
		downloadTask.resume()
	}
	
	func deleteFile(for cell: AvailableItemTableViewCell) { //Deletes the file associated with the cell'Ws item
		urls(for: cell.availableItem).forEach {try? FileManager.default.removeItem(at: $0)}
		fetchDownloaded()
		cell.updateSaved()
	}
	
	func deleteItem(at indexPath: IndexPath) {
		guard !availableSelected && downloadedItems.count > indexPath.row else {return}
		let url = downloadedItems[indexPath.row].url
		try? FileManager.default.removeItem(at: url)
		fetchDownloaded()
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	func share(_ url: URL) {
		let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		present(activityController, animated: true)
	}
}
