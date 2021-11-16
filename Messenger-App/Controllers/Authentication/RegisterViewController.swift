//
//  RegisterViewController.swift
//  Messenger-App
//
//  Created by administrator on 01/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import JGProgressHUD
class RegisterViewController: UIViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    // Firebase Login / check to see if email is taken
    // try to create an account
   

    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordNewTextFaild.isSecureTextEntry = true
        StyleButton.clipsToBounds = true

        profileImageView.clipsToBounds = true
//        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        StyleButton.layer.cornerRadius = StyleButton.frame.width / 2
    }
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var FirstNameTextFaild: UITextField!
    
    @IBOutlet weak var LastNameTextfaild: UITextField!
    
    @IBOutlet weak var EmailAddressTextFaild: UITextField!
       
    @IBOutlet weak var PasswordNewTextFaild: UITextField!
    @IBOutlet weak var StyleButton: UIButton!
    private let database = Database.database().reference()
    @IBAction func TakePhoto(_ sender: Any) {
        showPhoto()
      
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
   
    func showPhoto(){
        let alert = UIAlertController(title: "Take Photo Form:", message:nil , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Camera", style: .default, handler: {action in self.getPhoto(type: .camera) }))
        alert.addAction(UIAlertAction(title:"Photo Library", style: .default, handler: {action in self.getPhoto(type: .photoLibrary) }))
    
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        present(alert,animated: true, completion: nil)
}
 
    func getPhoto(type: UIImagePickerController.SourceType){
        let Picker = UIImagePickerController()
        Picker.sourceType = type
        Picker.allowsEditing = false
        Picker.delegate = self
        present(Picker,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("image not found")
            return
    }
        profileImageView.image = image
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

    @IBAction func RegisterButton(_ sender: UIButton) {
        // Firebase Login / check to see if email is taken
        // try to create an account
        
        DatabaseManger.shared.userExists(with: self.EmailAddressTextFaild.text!, completion: { [weak self ] exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else {
                strongSelf.alertUserLoginError(massege: " that email address already exsist")
                return
            }
           
            FirebaseAuth.Auth.auth().createUser(withEmail: self!.EmailAddressTextFaild.text!, password: self!.PasswordNewTextFaild.text!, completion: { authResult , error  in
                guard  authResult != nil, error == nil else {
                    print("Error creating user")
                    return
                }
                let chatUser = ChatAppUser(firstName: (self?.FirstNameTextFaild.text!)!, lastName: (self?.LastNameTextfaild.text!)!, emailAddress: (self?.EmailAddressTextFaild.text!)!)
                DatabaseManger.shared.insertUser(with: chatUser, completion: { success in if success {
                    guard let image = strongSelf.profileImageView.image , let data = image.pngData()else {
                        return
                    
                    }
                    let filename = chatUser
                        .profilePictureFileName
                    StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: {result in
                        switch result{
                        case.success(let downloadUrl):
                            print(downloadUrl)
                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                        case.failure(let error):
                            print("Storage manger error: \(error)")
                        }
                    })
                }})
            })
        })
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    
    }
    func alertUserLoginError(massege: String = "Please enter all Information to creat a new account."){
        let alert = UIAlertController(title: "Wrong", message: massege , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
