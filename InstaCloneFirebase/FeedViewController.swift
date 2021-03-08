//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Midilli on 7.03.2021.
//

import UIKit
import Firebase
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation
        tableView.delegate = self
        tableView.dataSource = self

        getDataFromFirestore()
    }
    //getting data from server/firestore
    func getDataFromFirestore() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    //reload after adding new datas
                    self.tableView.reloadData()
                }
            }
        }
        
        
        
            //date for old versions
        /*let settings = fireStoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fireStoreDatabase.settings = settings*/
        
    }
    
    
    //require tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    //require tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //call tableview feedcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //to download image
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    


}
