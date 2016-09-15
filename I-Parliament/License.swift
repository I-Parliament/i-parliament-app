//
//  License.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 14/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import Foundation

enum LicenseInfo {
	case url(String)
	case fileName(String)
}

struct License {
	var name: String
	var info: LicenseInfo
	
	var licenseText: String? {
		guard case let .fileName(name) = info,
			let path = Bundle.main.path(forResource: name, ofType: "txt")
			else {return nil}
		return try? String(contentsOfFile: path)
	}
}
