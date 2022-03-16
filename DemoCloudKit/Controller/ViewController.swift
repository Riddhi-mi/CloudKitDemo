//
//  ViewController.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 23/02/22.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    //MARK: - Outlets -
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: - Declared Varibales -
    var items = [String]()
    var recordArray = [RecordModel]()
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
}

//MARK: - Initialization -
extension ViewController {
    
    private func initialization() {
        self.title = "Grocery List"
        registerCell()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let nextVc = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didtapNextVC))
        let referenceVc = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapreferenceVc))
        navigationItem.rightBarButtonItems = [addButton, nextVc, referenceVc]
        fetchData()
    }
    
    private func registerCell() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //... To fetch Data
    private func fetchData() {
        self.recordArray.removeAll()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Title", predicate: predicate)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                DispatchQueue.main.async {
                    records?.forEach({ record in
                        self.recordArray.append(RecordModel(name: record.value(forKey: "title") as! String, id: record.value(forKey: "id") as! String))
                    })
                    self.tableview.reloadData()
                }
            } else {
                print("error fetching data", error)
            }
        }
    }
    
    @objc private func didTapreferenceVc() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didtapNextVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AssetViewController") as! AssetViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapAddButton() {
        let alert  = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                self.saveItem(title: text)
            }
        }))
            self.present(alert, animated: true, completion: nil)
    }
    
    //... To save Record
    private func saveItem(title: String) {
        let record = CKRecord(recordType: "Title")
        record.setValue("\(UUID())", forKey: "id")
        record.setValue(title, forKey: "title")
        CloudKitManager().addRecord(record: record) { record, error in
            if error == FetchError.none {
                print("record Saved")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchData()
                }
            } else {
                print("couldn't be able to add data", error)
            }
        }
    }
    
    //... To Edit a record
    private func editItem(newTitle: String, id: String) {
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: "Title", predicate: predicate)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                let record = records?.first
                record?.setValue(newTitle, forKey: "title")
                CloudKitManager().updateRecord(record!) { newRecord, error in
                    if error ==  FetchError.none {
                        print("Record Saved")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.fetchData()
                        }
                    } else {
                        print("Record Not Saved", error)
                    }
                }
            } else {
                print("Could not fetch record", error)
            }
        }
    }
    
    //... To delete a record using record Id
    private func deleteItem(id: String) {
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: "Title", predicate: predicate)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                let record = records?.first
                CloudKitManager().deleteRecord(recordId: record!.recordID) { error in
                    if error == FetchError.none {
                        print("Record \(id) Deleted")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.tableview.reloadData()
                        }
                    } else {
                        print("Record Not Deleted")
                    }
                }
            }
        }
    }
    
}

//MARK: - Tableview delegate methods -
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, completion) in
            let id = self.recordArray.remove(at: indexPath.row).id
            self.deleteItem(id: id)
            self.tableview?.deleteRows(at: [indexPath], with: .none)
            completion(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "edit") { (action, view, completion) in
            let alert  = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
            alert.addTextField { field in
                field.placeholder = "Enter name..."
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
                if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                    let id = self.recordArray[indexPath.row].id
                    self.editItem(newTitle: field.text ?? "", id: id)
                }
            }))
                self.present(alert, animated: true, completion: nil)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [edit, delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}


//MARK: - Tableview datasource methods -
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = recordArray[indexPath.row].name
        return cell
    }
    
}
