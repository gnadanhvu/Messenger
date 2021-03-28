//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Vu Dang Anh on 15.03.21.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private var users = [[String: String]]()
    private var results = [[String: String]]()
    
    private var hasFetched = false
    
    private let searchbar: UISearchBar = { //Searchbar erstellt
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..." //was in der Searchbar drin steht wenn nichts eingetippt wird
        return searchBar
    }()
    
    
    private let tableView: UITableView = {
       
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultLabel: UILabel = {
        
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.text = "no Result"
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchbar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchbar //die Searchbar wird zum NavigationController hinzugefügt, kein Positionieren mehr nötig
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .done, target: self, action: #selector(dismissSelf)) //Abbrechentaste oben Rechts
        
        searchbar.becomeFirstResponder() //keyboard öffnet sich direkt
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds //ganzes Bildschirm
        noResultLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    
    @objc private func dismissSelf () { //Abbrechen taste
        dismiss(animated: true, completion: nil)
    }



}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //start conversation
    }
    
}


extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchbar Text wird hinzugefügt, LeerZeichen werden gelöscht
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        
        }
        searchbar.resignFirstResponder() //searchbar geht direkt weg
        
        
        results.removeAll() //alte Results werden entfernt
        spinner.show(in: view)
        
        self.searchUsers(query: text) //Text wird der Funktion searchUsers gegeben

    }
    func searchUsers(query: String){
        //check if array has firebase result
        if hasFetched{
            //if it does: filter
            filterUsers(with: query) //ruft die Funktion auf und übergibt den String: Query
        }
        else {
            //wenn nicht, alle Users in usersCollection speichern
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case . success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("failed to get users: \(error)")
                }
            })
        }
    }
    
    
    //Filtert User mit dem was wir geschrieben haben
    func filterUsers(with term : String) {
        //update the UI: either show result or show no result
        
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss()
        //results wird in users gepseichert
        let results: [[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            
            
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
       
        updateUI()
    }
    
    func updateUI() {
        //Update UI wenn etwas drin ist oder nicht
        if results.isEmpty{
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
