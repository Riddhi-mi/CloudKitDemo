//
//  UserDetailViewController.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 25/02/22.
//

import UIKit
import CloudKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var txtfieldDesgination: UITextField!
    @IBOutlet weak var txtfieldAge: UITextField!
    @IBOutlet weak var txtfieldCompanyName: UITextField!
    @IBOutlet weak var txtfielduserName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    //MARK: - Declared Variables -
    var recordId: CKRecord.ID?
    var recordName: String?
    var isAdd: Bool = false
     
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.title = "User Details"
        if isAdd == false {
            self.fetchItems(id: recordId!)
        }
    }
}

//MARK: - Initialization -
extension UserDetailViewController {
    
    private func initialize() {
        setAddEdit()
    }
    
    private func setAddEdit() {
        if isAdd == true {
            txtfieldDesgination.isUserInteractionEnabled = true
            txtfieldAge.isUserInteractionEnabled = true
            txtfieldCompanyName.isUserInteractionEnabled = true
            txtfielduserName.isUserInteractionEnabled = true
            btnSubmit.isHidden = false
        } else {
            txtfieldDesgination.isUserInteractionEnabled = false
            txtfieldAge.isUserInteractionEnabled = false
            txtfieldCompanyName.isUserInteractionEnabled = false
            txtfielduserName.isUserInteractionEnabled = false
            btnSubmit.isHidden = true
        }
    }
    
    private func fetchItems(id: CKRecord.ID) {
        let reference = CKRecord.Reference(recordID: id, action: .deleteSelf)
        let pred = NSPredicate(format: "parentReference == %@", reference)
        let query = CKQuery(recordType: userDetailsRecordType, predicate: pred)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                DispatchQueue.main.async {
                    records?.forEach({ [self] record in
                        txtfielduserName.text = recordName
                        txtfieldAge.text = record["age"] as? String
                        txtfieldCompanyName.text = record["companyName"] as? String
                        txtfieldDesgination.text = record["desgination"] as? String
                    })
                }
            } else {
                print("error fetching data", error)
            }
        }
    }
    
    private func saveItem(name: String) {
        let record = CKRecord(recordType: userNamesRecordType)
        record.setValue(name, forKey: "userName")
        CloudKitManager().addRecord(record: record) { record, error in
            if error == FetchError.none {
                print("record Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("username saves successfully")
                    self.saveReference(id: record!.recordID)
                }
            } else {
                print("couldn't be able to add data", error)
            }
        }
    }
    
    private func saveReference(id: CKRecord.ID) {
        let record = CKRecord(recordType: userDetailsRecordType)
        let reference = CKRecord.Reference(recordID: id, action: .deleteSelf)
        record["companyName"] = txtfieldCompanyName.text
        record["age"] = txtfieldAge.text
        record["desgination"] = txtfieldDesgination.text
        record["parentReference"] = reference
        CloudKitManager().addRecord(record: record) { record, error in
            if error == FetchError.none {
                print("record Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("data saved successfully")
                }
            } else {
                print("couldn't be able to add data", error)
            }
        }
    }
}

//MARK: - IBActions -
extension UserDetailViewController {
    
    @IBAction private func didtapSubmit(_ sender: UIButton){
        saveItem(name: txtfielduserName.text!)
        navigationController?.popViewController(animated: true)
    }
}
