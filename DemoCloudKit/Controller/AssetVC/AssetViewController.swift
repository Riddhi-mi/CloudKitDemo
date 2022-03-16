//
//  AssetViewController.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//

import UIKit
import CloudKit

class AssetViewController: UIViewController {
    //MARK: - Declared Variables -
    @IBOutlet weak var collectionview: UICollectionView!
    
    //MARK: - Declared Variables -
    var assetsArray = [AssetModel](){
        didSet{
            DispatchQueue.main.async {
                self.collectionview.reloadData()
            }
        }
    }
    
    //MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.title = "Assets"
    }
}

//MARK: - Initialization -
extension AssetViewController {
    
    private func initialize() {
       regsterCollectionCell()
        self.fetchData()
    }
    
    private func saveData(image: UIImage) {
        let record = CKRecord(recordType: assetRecordType)
        let fileURL = docDir.appendingPathComponent("NewPicture.jpg")
        record.setValue(fileURL.lastPathComponent, forKey: "name")
        do {
            try image.jpegData(compressionQuality: 1)!.write(to: fileURL)
            let asset = CKAsset(fileURL: fileURL)
            record.setObject(asset, forKey: "picture")
        } catch {
            print("Error saving image to URL")
            print(error)
        }
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
    
    private func fetchData() {
        let predicate = NSPredicate(value: true)
        self.assetsArray.removeAll()
        let query = CKQuery(recordType: assetRecordType, predicate: predicate)
        CloudKitManager().fetchRecords(query: query) { records, error in
            if records != nil {
                DispatchQueue.main.async {
                    records?.forEach({ record in
                            let fetchImage: CKAsset? = record.object(forKey: "picture") as? CKAsset
                            let data = NSData(contentsOf: fetchImage?.fileURL ?? URL(fileURLWithPath: ""))
                            let image = UIImage(data: data! as Data)
                            if record.value(forKey: "name") == nil {
                                self.assetsArray.append(AssetModel(id: record.recordID, name: "name", imageURL: image ?? UIImage()))
                            } else {
                                self.assetsArray.append(AssetModel(id: record.recordID, name: record.value(forKey: "name") as! String, imageURL: image ?? UIImage()))
                        }
                    })
                }
            } else {
                print("error fetching data", error)
            }
        }
    }
    
    private func regsterCollectionCell() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionCellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapSelectImageButton))
    }
    
    
    @objc private func didTapSelectImageButton() {
        self.view.endEditing(true)
        topMostViewController?.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: "Choose", btnOneTitle: "Camera", btnOneTapped: { _ in
            CMediaManagerShared.takePhotoFromCamera { image, info in
                self.saveData(image: image ?? UIImage())
            }
        }, btnTwoTitle: "Gallery", btnTwoTapped: { _ in
            CMediaManagerShared.chooseFromGallery { image, info in
                self.saveData(image: image ?? UIImage())
            }
        })
    }
    
}


//MARK: - Collection View delegate methods -
extension AssetViewController: UICollectionViewDelegate {
}


//MARK: - Collection View datasource methods -
extension AssetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! AssetCollectionViewCell
        cell.image.image = assetsArray[indexPath.row].imageURL
        return cell
    }
}


//MARK: - Collection View flowlayout methods -
extension AssetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:( collectionView.frame.width / 3) - 15 , height: (collectionView.frame.width / 3) - 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
}
