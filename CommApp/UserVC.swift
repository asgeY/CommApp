//
//  UserVC.swift
//  CommApp
//
//  Created by Asgedom Yohannes on 12/3/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class UserVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var completeSignInBtn: UIButton!
    
    
    var userUid: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var userName: String!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePickerController.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
        // Do any additional setup after loading the view.
        
        func keychain(){
            
            KeychainWrapper.standard.set(userUid, forKey: "uid")
        
    }
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard (info[.originalImage] as? UIImage) != nil else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let image = info[.originalImage] as? UIImage {
            userImagePicker.image = image
            imageSelected = true
        }else{
            print("Image was not Selected!")
        }
        imagePicker .dismiss(animated: true, completion: nil)
    }
    
    func setUpUser(img: String){
        
        let userData = [
            "username": userName!,
            "userImg": img
        ]
        
        keychain()
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        
        setLocation.setValue(userData)
    }
    
    func uploadImage(){
        if userNameField.text == nil {
            print("Must have User Name!")
            completeSignInBtn.isEnabled = false
            
        }else {
            userName = userNameField.text
            completeSignInBtn.isEnabled = true
            
        }
        guard let img = userImagePicker.image,imageSelected == true else {
            print("Image must be selected!")
            return
        }
        
        
        if let imgData = img.jpegData(compressionQuality: 0.2){
            let imageUid = NSUUID().uuidString
            let storageRef = StorageReference()
            Storage.storage().reference().child(imageUid).putData(imgData, metadata: nil, completion: {(metaData,error)in
                
                if error != nil {
                    print("Did not upload Image!")
                    
                }else {
                    print("Uploaded")
                    
                    storageRef.downloadURL(completion:{(url,error)in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if  url != nil {
                            self.setUpUser(img: url!.absoluteString)
                        }
                        
                    })
                }
            })
        }
    }
    
    @IBAction func completeAccount (_sender: AnyObject){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: {(user,error)in
            
            if error != nil {
                print("Error")
                
            }else {
                if let user = user {
                    self.userUid = user.user.uid
                }
            }
            self.uploadImage()
            
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedImagePicker(_sender: AnyObject){
        present(imagePicker,animated: true,completion: nil)
    }
    
    @IBAction func cancel(_sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
}
