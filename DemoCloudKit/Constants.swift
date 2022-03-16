//
//  Constants.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//

import Foundation
import CloudKit


let recordType = "GroceryItem"
let assetRecordType = "AssetItems"
let userNamesRecordType = "usernames"
let userDetailsRecordType = "userDetails"
let collectionCellIdentifier = "AssetCollectionViewCell"
let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let container = CKContainer(identifier: "iCloud.com.mi.all").publicCloudDatabase
