<a href="https://docs.swift.org/swift-book/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/swift-5.0-brightgreen">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-red">
</a>
<a href="https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=nikunjprajapati95/Reading-Animation&amp;utm_campaign=Badge_Grade"><img src="https://app.codacy.com/project/badge/Grade/44b16d6ddb96446b875d38bf2ec89b11"/></a>
<a href="https://github.com/nikunjprajapati95/Reading-Animation/blob/main/LICENSE" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/licence-MIT-orange">
</a>
<p></p> 

# CloudKitDemo

The CloudKit framework provides interfaces for moving data between your app and your iCloud containers. You use CloudKit to store your app’s existing data in the cloud so that the user can access it on multiple devices.

## Requirements

Xcode 9+
iOS 11+

# Implementation

Here's the link to my blog for implementation of CloudKit and it's usage.


## Usage
Create a container to store records.
```swift
let container = CKContainer.default().publicCloudDatabase
```
## Create Record
To create a record to CloudKit Database, you also have to set value for a key like UserDefaults in cloudkit.
```swift
let record = CKRecord(recordType: "Title")
record.setValue("\(UUID())", forKey: "id")
record.setValue(title, forKey: "title")
container.save(record, completionHandler: { (record, error) in
 })
```

## Fetch Record
To fetch a record from CloudKit Database, you have to use a query of CKQuery type which takes predicate and RecordType as parameter and then you pass that query.
```swift
let predicate = NSPredicate(value: true)
let query = CKQuery(recordType: "RECORD_TYPE", predicate: predicate)
container.perform(query, inZoneWith:  CKRecordZone.default().zoneID, completionHandler: { (records, error) in
  })
```
If you want to fetch a single record you can fetch it using CKRecord.Id a unique identifier in CloudKit to distinguish between Records.
```swift
container.fetch(withRecordID: id) { record, error in
  }
```

or 

You can use query as well of CKQuery to query records.
```swift
let predicate = NSPredicate(value: true)
let query = CKQuery(recordType: "Title", predicate: predicate)
container.perform(query, inZoneWith:  CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
 })
```

## Delete Record
To delete a record from CloudKit Database. You have to pass in CKRecord.ID a unique identifier in CloudKit to distinguish between Records.
```swift
container.delete(withRecordID: record.recordID) { (recordID, error) -> Void in
 }
```

## Update Record
To update a record you have to update the record you have to fetch record using ID and then using the key update a newValue to it.
```swift
container.fetch(withRecordID: id) { record, error in
record?.setValue(NEW_TITLE, forKey: "title")
container.save(record, completionHandler: { (record, error) in
 })
}
```
or 

If you have created a unique identifier of string from yourself, you can use this as well!
```swift
let predicate = NSPredicate(format: "id == %@", id)
let query = CKQuery(recordType: "Title", predicate: predicate)
container.perform(query, inZoneWith:  CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
 })
}
```
<br></br>

## 📱 Check out other lists of our Mobile UI libraries

<a href="https://github.com/Mindinventory?language=kotlin"> 
<img src="https://img.shields.io/badge/Kotlin-0095D5?&style=for-the-badge&logo=kotlin&logoColor=white"> </a>

<a href="https://github.com/Mindinventory?language=swift"> 
<img src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white"> </a>

<a href="https://github.com/Mindinventory?language=dart"> 
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"> </a>


<a href="https://github.com/Mindinventory/react-native-tabbar-interaction"> 
<img src="https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB"> </a>

<br></br>

## 💻 Check out other lists of Web libraries

<a href="hhttps://github.com/Mindinventory?language=javascript"> 
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"></a>

<a href="https://github.com/Mindinventory?language=go"> 
<img src="https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white"></a>

<a href="https://github.com/Mindinventory?language=python"> 
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"></a>

<br></br>

<h4><a href="https://www.mindinventory.com/whitepapers.php?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell#demo"><u> 📝 Get FREE Industry WhitePapers →</u></a></h4>

## Check out our Work
<a href="https://dribbble.com/mindinventory"> 
<img src="https://img.shields.io/badge/Dribbble-EA4C89?style=for-the-badge&logo=dribbble&logoColor=white" /> </a>
<br></br>

## 📄 License
MI-Circular Slider is [MIT-licensed](/LICENSE).


If you use our open-source libraries in your project, please make sure to credit us and Give a star to www.mindinventory.com

<a href="https://www.mindinventory.com/contact-us.php?utm_source=gthb&utm_medium=repo&utm_campaign=swift-ui-libraries">
<img src="https://github.com/Sammindinventory/MindInventory/blob/main/hirebutton.png" width="203" height="43"  alt="app development">
</a>


