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




