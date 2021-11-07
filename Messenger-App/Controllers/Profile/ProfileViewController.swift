//
//  ProfileViewController.swift
//  Messenger-App
//
//  Created by administrator on 31/10/2021.
//


import UIKit

import FirebaseAuth
class ProfailViewController: UIViewController, UITableViewDelegate {
   
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Log Out"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        func createTableHeader() -> UIView? {
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return nil
            }
        let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
            let headerView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: self.view.width,
                                            height: 300))
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.imageProfile.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        
    
        func downloadImage(imageProfile : UIImageView , url : URL ){
            URLSession.shared.dataTask(with: url, completionHandler: {data , error,_ in guard let data = data , error == nil else {
                return
            }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    imageProfile.image = image
                }
            }) .resume()
        }
   return headerView
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // unhighlight the cell
        // logout the user
        
        // show alert
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            // action that is fired once selected
            
            guard self != nil else {
                return
            }
            
          
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self?.navigationController?.pushViewController(vc, animated: true)
                // present login view controller
               // self?.dismiss(animated: true)
                // let sb = UIStoryboard(name: "Main", bundle: nil)
               // let vc = sb.instantiateViewController(withIdentifier: "ProfailViewController")
                // let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                strongSelf.present(nav, animated: true)
            }
            catch {
                print("failed to logout")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    }}

