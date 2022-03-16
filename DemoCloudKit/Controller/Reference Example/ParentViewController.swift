//
//  ReferenceViewController.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 25/02/22.
//

import UIKit
import CloudKit

class ParentViewController: UIViewController {
    //MARK: - Outlets -
    @IBOutlet private weak var tableview: UITableView!
    var textfieldText: String?
    var userNames = [UserModel]()
    
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialize()
        self.title = "User Names"
    }
}

//MARK: - Initialization -
extension ParentViewController {
    
    private func initialize() {
        self.registerCell()
        let addDetails = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addDetails
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.fetchData()
        }
        
    }
    
    private func registerCell() {
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    private func fetchData() {
        let predicate = NSPredicate(value: true)
        self.userNames.removeAll()
        let query = CKQuery(recordType: userNamesRecordType, predicate: predicate)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                DispatchQueue.main.async {
                    records?.forEach({ record in
                        self.userNames.append(UserModel(name: record.value(forKey: "userName") as! String, id: record.recordID))
                    })
                    self.tableview.reloadData()
                }
            } else {
                print("error fetching data", error)
            }
        }
    }
    
    private func deleteItem(id: CKRecord.ID) {
        CloudKitManager().deleteRecord(recordId: id) { error in
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
    
    @objc private func didTapAddButton() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        vc.isAdd = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - tableview delegate methods -
extension ParentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        vc.recordId = userNames[indexPath.row].id
        vc.isAdd = false
        vc.recordName = userNames[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, completion) in
            let id = self.userNames.remove(at: indexPath.row).id
            self.deleteItem(id: id)
            self.tableview?.deleteRows(at: [indexPath], with: .none)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}


//MARK: - tableview datasource methods -
extension ParentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = userNames[indexPath.row].name
            content.textProperties.color = .black
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = userNames[indexPath.row].name
        }
        return cell
    }
}
