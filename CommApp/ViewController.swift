//
//  ViewController.swift
//  CommApp
//
//  Created by Asgedom Yohannes on 11/30/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            goToFeedVC()
        }
    }
    
    func gotToCreateUserVC(){
        
        performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    func goToFeedVC(){
        
        performSegue(withIdentifier: "ToFeed", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SignUp"{
            if let destination = segue.destination as? UserVC {
                if userUid != nil {
                    destination.userUid = userUid
                }
                if emailField != nil {
                    destination.emailField = emailField.text
                }
                if passwordField != nil {
                    destination.passwordField = passwordField.text
                }
            }
        }
    }
    @IBAction func signInPressed(_sender: Any){
        
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user,error)in
                if error == nil{
                    if let user = user {
                        self.userUid = user.user.uid
                        self.goToFeedVC()
                    }
                }else {
                    self.gotToCreateUserVC()
                }
            })
        }
    }

}

