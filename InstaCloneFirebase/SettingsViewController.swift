//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Midilli on 7.03.2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        //to logout
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
        
    }
      

}
