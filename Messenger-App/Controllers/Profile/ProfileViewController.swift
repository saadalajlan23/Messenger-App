//
//  ProfileViewController.swift
//  Messenger-App
//
//  Created by administrator on 31/10/2021.
//

import UIKit

import FirebaseAuth
class ProfailViewController: UIViewController {
    let data = ["Log Out"]
        
    
    @IBOutlet weak var tableview: UITableView!
    
override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableHeaderView = creatTableHeader()
        
    }
    @IBOutlet weak var pic: UIImageView!
    func creatTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "emailn") as? String  else {
            return nil
        }
        let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: 414 , height: 300))
        headerview.backgroundColor = .link
        let iamgeView = UIImageView(frame: CGRect(x: 132, y: 75, width: 150, height: 150))
       
        iamgeView.contentMode = .scaleAspectFill
        iamgeView.backgroundColor = .white
        iamgeView.layer.borderColor = UIColor.white.cgColor
        iamgeView.layer.borderWidth = 3
        iamgeView.layer.masksToBounds = true
        iamgeView.layer.cornerRadius = 150/2
        headerview.addSubview(pic)
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            
            case .success(let url):
                self?.downloadImage(pic: self!.pic, url: url)
            case .failure(let error):
                print("Faild to get download url: \(error)")
            }
        })
        
        return headerview
    }
    
    func downloadImage(pic: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {data, _ , error in
            guard let data = data , error == nil else{
                return
            }
            DispatchQueue.main.async{
                let image = UIImage(data: data)
                self.pic.image = image
            }
        }).resume()
    }
}
extension ProfailViewController: UITableViewDelegate, UITableViewDataSource {
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
            
            guard let strongSelf = self else {
                return
            }
            
          
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavection")
                self?.view.window?.rootViewController = vc
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
    
}


