//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Midilli on 7.03.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //before select image
        uploadButton.isEnabled = false
        
        //enable to tap to imageview
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    //select image func
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //for zooming or cropping
        picker.allowsEditing = true
        //show the picker
        present(picker, animated: true, completion: nil)
    }
    
    //after picking photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        //close picker
        self.dismiss(animated: true, completion: nil)
        //make touchable after choose photo
        uploadButton.isEnabled = true
    }
    
    //alert func
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
    //upload
        let storage = Storage.storage()
        let storageReference = storage.reference()
        //choosing folder if it is not existing it will create automaticilly
        let mediaFolder = storageReference.child("media")
        //convert image to data, 0.5 is compression rate
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            //creating image name and uuid
            let uuid = UUID().uuidString
            //save as jpg
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            //convert url to string
                            let imageUrl = url?.absoluteString
                            //DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    //get default value on upload page
                                    self.imageView.image = UIImage(named: "select")
                                    self.commentText.text = ""
                                    //if no error goes to feedVC
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
}
