//
//  CreditsTableViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 12/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class CreditsTableViewController: UITableViewController {
	
	let licenses = [
		License(name: "Icons8", info: .url("https://icons8.com")),
		License(name: "Google Maps SDK for iOS", info: .fileName("Google Maps"))
	]
	
	@IBAction func doneTapped(_ sender: AnyObject) {
		dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return licenses.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath)
		
		let license = licenses[indexPath.row]
		cell.textLabel?.text = license.name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let license = licenses[indexPath.row]
		if case let .url(stringURL) = license.info,
			let url = URL(string: stringURL) {
			UIApplication.shared.openURL(url)
		} else {
			performSegue(withIdentifier: "licenseSegue", sender: nil)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? LicenseViewController,
			let selectedRow = tableView.indexPathForSelectedRow?.row
			else {return}
		let license = licenses[selectedRow]
		destination.licenseText = license.licenseText
		destination.title = license.name
	}

}
