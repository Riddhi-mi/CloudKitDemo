//
//  CloudKitHelper.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 25/02/22.
//

import Foundation
import CloudKit

enum FetchError {
    case addingError, fetchingError, deletingError, noRecords, noRecord, none
}

class CloudKitManager {
    
    let container = CKContainer.default().publicCloudDatabase
    
    func addRecord(record: CKRecord, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        container.save(record, completionHandler: { (record, error) in
            guard let _ = error else {
                completionHandler(record, .none)
                return
            }

            completionHandler(nil, .addingError)
        })
    }

    func fetchRecords(query: CKQuery, completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        container.perform(query, inZoneWith:  CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
            self.processQueryResponseWith(records: records, error: error as NSError?, completion: { fetchedRecords, fetchError in
                completion(fetchedRecords, fetchError)
            })
        })
    }
    
    func fetchWithId(id: CKRecord.ID, completion: @escaping (CKRecord?, FetchError) -> Void){
        container.fetch(withRecordID: id) { record, error in
            self.processQueryResponseWithRecord(record, error: error as NSError?) { fetchedRecord, fetchedError in
                completion(fetchedRecord, fetchedError)
            }
        }
    }
    
    private func processQueryResponseWithRecord(_ record: CKRecord?, error: NSError?, completion: @escaping (CKRecord?, FetchError) -> Void) {
        guard error == nil else {
            print(error!.localizedDescription)
            completion(nil, .fetchingError)
            return
        }
        
        guard let record = record else {
            completion(nil, .noRecord)
            return
        }
        
        completion(record, .none)
    }
    

    private func processQueryResponseWith(records: [CKRecord]?, error: NSError?, completion: @escaping ([CKRecord]?, FetchError) -> Void) {
        guard error == nil else {
            print(error!.localizedDescription)
            completion(nil, .fetchingError)
            return
        }
        
        guard let records = records, records.count > 0 else {
            completion(nil, .noRecords)
            return
        }
        
        completion(records, .none)
    }
    
    
    func deleteRecord(recordId: CKRecord.ID, completionHandler: @escaping (FetchError) -> Void) {
        container.delete(withRecordID: recordId) { (recordID, error) -> Void in
            guard let _ = error else {
                completionHandler(.none)
                return
            }
            
            completionHandler(.deletingError)
        }
    }
    
    func updateRecord(_ record: CKRecord, completionHandler: @escaping (CKRecord?, FetchError) -> Void) {
        container.save(record, completionHandler: { (record, error) in
            guard let _ = error else {
                completionHandler(record, .none)
                return
            }
            completionHandler(nil, .addingError)
        })
    }
}
