//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Vu Dang Anh on 15.03.21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    
    let data = ["Log Out"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader() //Func gibt einen UIView an das tableView
        
        
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("geht nicht du Hund ")
            return nil
        }
        print("key value ist:  \(UserDefaults.standard.value(forKey: "email"))")
        
        let safeEmail = DatabaseManager.safeEmail(emailAdress: email) //email abspeichern in safeEmail
        let filename = safeEmail + "_profile_picture.png" //email wird mit der Endung zusammen gefügt
        let path = "images/"+filename //Pfad Namen erzeugen
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        
        headerView.backgroundColor = .link
    
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2 , y: 75, width: 150, height: 150))
        
       
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = imageView.width/2
        
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
              self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
            print("Failed to get download url: \(error)")
                }
                                          
            })
        return headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _ , error in
            guard let data = data, error == nil else { //wenn data was vorhanden ist und kein error ...
                print("hat nicht funktioniert")
                return
            }
            print("hat funktioniert!")
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            
            
            FBSDKLoginKit.LoginManager().logOut()
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController() //  wechseln ViewController "LoginViewController"
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen   //Präsentationsmethode
                
                strongSelf.present(nav, animated: true)
            }
            catch{
            print("failed to log out")
            
        }
            
        }))
       
        
        actionSheet.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))

        
        
       present(actionSheet, animated: true)
    
}

}
