//
//  DownloadsTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 07/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

extension String {
	static let availableCell = "availableCell"
	static let availableGroupCell = "availableGroupCell"
	static let downloadedCell = "downloadedCell"
}

class DownloadsTableViewController: UITableViewController {
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var availableGroups = [
		AvailableGroup(
			title: "Group 1",
			items: [
				AvailableItem(title: "Item 1"),
				AvailableItem(title: "Item 2")
			]
		),
		AvailableGroup(
			title: "Group 2",
			items: [
				AvailableItem(title: "Item 3")
			]
		)
	]
	
	var availableSelected: Bool {
		return segmentedControl.selectedSegmentIndex == 0
	}
	
	var downloadedItems = [
		DownloadedItem(title: "Hi"),
		DownloadedItem(title: "Bye")
	]
	
	@IBAction func segmentChanged(_ sender: AnyObject) {
		isEditing = false
		navigationItem.setLeftBarButton(availableSelected ? nil : editButtonItem, animated: true)
		
		let animationDirection: UITableViewRowAnimation = availableSelected ? .right : .left
		
		if availableGroups.count == 0 {
			let updateSections = availableSelected ? tableView.deleteSections : tableView.insertSections
			updateSections([0], animationDirection)
		} else if availableGroups.count == 1 {
			tableView.reloadSections([0], with: animationDirection)
		} else {
			let indexRange = Range(uncheckedBounds: (1, availableGroups.count))
			let indexSet = IndexSet(integersIn: indexRange)
			let updateSections = availableSelected ? tableView.insertSections : tableView.deleteSections
			
			tableView.beginUpdates()
			tableView.reloadSections([0], with: animationDirection)
			updateSections(indexSet, .left)
			tableView.endUpdates()
		}
	}
	
	override func viewDidLoad() {
		//TODO: Download file list from the internet
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return availableSelected ? availableGroups.count : 1
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if availableSelected {
			return (availableGroups[section].expanded ? availableGroups[section].items.count : 0) + 1 //One extra row for group name
		}
		return downloadedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !availableSelected { //Downloaded item
			let cell = tableView.dequeueReusableCell(withIdentifier: .downloadedCell, for: indexPath)
			cell.textLabel?.text = downloadedItems[indexPath.row].title
			return cell //Doesn't fall through
		}
		let rowGroup = availableGroups[indexPath.section]
		if indexPath.row == 0 { //Available Group
			let cell = tableView.dequeueReusableCell(withIdentifier: .availableGroupCell, for: indexPath) as! AvailableGroupTableViewCell
			cell.availableGroup = rowGroup
			cell.updateDisclosureView()
			return cell
		} else { //Available Item
			let cell = tableView.dequeueReusableCell(withIdentifier: .availableCell, for: indexPath) as! AvailableItemTableViewCell
			cell.availableItem = rowGroup.items[indexPath.row - 1]
			return cell
		}
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? AvailableGroupTableViewCell {
			UIView.animate(withDuration: 0.3) {
				DispatchQueue.main.async {
					cell.twirl(in: self.tableView)
				}
			}
		} else if let cell = tableView.cellForRow(at: indexPath) as? AvailableItemTableViewCell {
			//TODO: Download file here
			print(cell.availableItem.title)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
