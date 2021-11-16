//
//  NewConversationViewController.swift
//  Messenger-App
//
//  Created by administrator on 31/10/2021.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationCell.identifier,
                                                 for: indexPath) as! NewConversationCell
        cell.configure(with: model)
        return cell
    }

    
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResulteLabel: UILabel!
    @IBOutlet weak var searshBar: UISearchBar!
    
    private let spinner = JGProgressHUD()
    public var completion: ((SearchResult) -> (Void))?

    

    private var users = [[String: String]]()

    private var results = [SearchResult]()

    private var hasFetched = false
    
      
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResulteLabel)
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        searshBar.delegate = self
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.titleView = searshBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searshBar.becomeFirstResponder()
    }
    
   @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
}
    
extension NewConversationViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }

        searchBar.resignFirstResponder()

        results.removeAll()
        spinner.show(in: view)

        searchUsers(query: text)
    }

    func searchUsers(query: String) {
        // check if array has firebase results
        if hasFetched {
            // if it does: filter
            filterUsers(with: query)
        }
        else {
            // if not, fetch then filter
            DatabaseManger.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get usres: \(error)")
                }
            })
        }
    }

    func filterUsers(with term: String) {
        // update the UI: eitehr show results or show no results label
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }

        let safeEmail = DatabaseManger.safeEmail(emailAddress: currentUserEmail)

        self.spinner.dismiss()

        let results: [SearchResult] = users.filter({
            guard let email = $0["email"], email != safeEmail else {
                return false
            }

            guard let name = $0["name"]?.lowercased() else {
                return false
            }

            return name.hasPrefix(term.lowercased())
        }).compactMap({

            guard let email = $0["email"],
                let name = $0["name"] else {
                return nil
            }

            return SearchResult(name: name, email: email)
        })

        self.results = results

        updateUI()
    }

    func updateUI() {
        if results.isEmpty {
            noResulteLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResulteLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

    }


