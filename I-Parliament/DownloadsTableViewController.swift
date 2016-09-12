//
//  DownloadsTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class DownloadsTableViewController: UITableViewController {
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var availableGroups = [AvailableGroup]()
	var dataTask: URLSessionDataTask?
	
	var availableSelected: Bool {
		return segmentedControl.selectedSegmentIndex == 0
	}
	
	var downloadedItems = [DownloadedItem]()
	
	@IBAction func segmentChanged(_ sender: AnyObject) {
		isEditing = false
		navigationItem.setLeftBarButton(availableSelected ? nil : editButtonItem, animated: true)
		
		let animationDirection: UITableViewRowAnimation = availableSelected ? .right : .left
		
		tableView.beginUpdates()
		tableView.reloadSections([0], with: animationDirection)
		if availableGroups.count > 1 { //We need to add or remove the extra section
			let indexSet = IndexSet(integersIn: Range(uncheckedBounds: (1, availableGroups.count)))
			let sectionFunction = availableSelected ? tableView.insertSections : tableView.deleteSections
			sectionFunction(indexSet, .left)
		}
		tableView.endUpdates()
	}
	
	override func viewDidLoad() {
		setupRefreshControl()
		refreshData()
	}
	
	//MARK:- Helper Functions
	
	private func setupRefreshControl() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}
	
	func refreshData() {
		fetchAvailable()
		fetchDownloaded()
	}
	
	func fetchAvailable() {
		guard let url = URL(string: "\(apiEndpoint)media?mime_type=application%2Fpdf") else {return}
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
			self.availableGroups = []
			for item in body {
				guard let stringURL = item["source_url"] as? String,
					let url = URL(string: stringURL),
					
					let title = item["title"] as? JSON,
					let renderedTitle = title["rendered"] as? String,
					
					let id = item["id"] as? Int,
					
					let itemDescription = item["description"] as? String
					else {return}
				
				let splitDescription = itemDescription.components(separatedBy: "Group: ")
				
				guard splitDescription.count == 2 else {continue} //Move on to the next item
				
				let groupName = splitDescription[1].htmlDecoded
				
				let availableItem = AvailableItem(id: id, title: renderedTitle.htmlDecoded, url: url)
				
				if let index = self.availableGroups.index(where: {$0.title == groupName}) {
					self.availableGroups[index].items.append(availableItem)
				} else {
					let availableGroup = AvailableGroup(title: groupName, items: [availableItem])
					self.availableGroups.append(availableGroup)
				}
			}
		}
		dataTask?.resume()
	}
	
	func fetchDownloaded() {
		let fileManager = FileManager.default
		
		guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
			let fileURLs = try? fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
			else {return}
		
		downloadedItems = []
		
		for fileURL in fileURLs {
			let fileParts = fileURL.lastPathComponent.components(separatedBy: "_")
			guard fileParts.count > 1 else {return}
			guard let lastPart = fileParts.last?.components(separatedBy: ".pdf").first,
				let id = Int(lastPart) else {return}
			let title = fileParts.dropLast().joined(separator: "_")
			
			let item = DownloadedItem(id: id, title: title, url: fileURL)
			downloadedItems.append(item)
		}
	}
	
	//MARK:- Table view data source
	
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
	
	func deleteItem(at indexPath: IndexPath) {
		guard !availableSelected && downloadedItems.count > indexPath.row else {return}
		let filePath = downloadedItems[indexPath.row].url
		try? FileManager.default.removeItem(at: filePath)
		
		fetchDownloaded()
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	//MARK:- Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let postController = segue.destination as? PostViewController,
			let selected = tableView.indexPathForSelectedRow
			else {return}
		
		if availableSelected {
			let group = availableGroups[selected.section]
			let item = group.items[selected.row - 1]
			postController.postType = .remote(url: item.url)
			postController.title = item.title
			return
		}
		
		let item = downloadedItems[selected.row]
		postController.postType = .local(url: item.url)
		postController.title = item.title
	}
}

extension DownloadsTableViewController: AvailableItemDownloadDelegate {
	
	func urls(for item: AvailableItem) -> [URL] {
		let fileManager = FileManager.default
		guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			else {return []}
		
		if let fileURLs = try? fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) {
			return fileURLs.filter { url in
				let lastComponent = url.lastPathComponent.components(separatedBy: "_").last
				let noExtension = lastComponent?.components(separatedBy: ".pdf").first ?? ""
				let id = Int(noExtension)
				return id == item.id
			}
		}
		
		return []
	}
	
	func download(item: AvailableItem) {
		let fileManager = FileManager.default
		guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {return}
		
		let itemURLs = urls(for: item)
		if !itemURLs.isEmpty {
			itemURLs.forEach {
				try? fileManager.removeItem(at: $0)
			}
			fetchDownloaded()
			tableView.reloadData()
			return
		}
		
		let saveURL = documents.appendingPathComponent(item.fileName)
		let downloadTask = URLSession.shared.downloadTask(with: item.url) { url, response, error in
			guard let url = url,
				error == nil
				else {return}
			
			try? fileManager.copyItem(at: url, to: saveURL)
			
			self.fetchDownloaded()
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		downloadTask.resume()
	}
}

extension String {
	var htmlDecoded: String {
		guard let encodedData = data(using: .utf8) else {return self}
		let attributeOptions: [String: Any] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
		]
		let attributedString = try? NSAttributedString(data: encodedData, options: attributeOptions, documentAttributes: nil)
		return attributedString?.string ?? self
	}
}
