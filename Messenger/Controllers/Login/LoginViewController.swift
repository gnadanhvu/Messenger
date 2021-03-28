//
//  LoginViewController.swift
//  Messenger
//
//  Created by Vu Dang Anh on 15.03.21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD


class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "logo")  //Bild holen
        ImageView.contentMode = .scaleAspectFit
        return ImageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no //keine korektur in der Email
        field.returnKeyType = .continue
        field.autocapitalizationType = .none //keine Großschreibung beachten
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field .placeholder = "Email Adresse..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0)) //Abstand im textfield damit der text nicht direkt am Rand ist
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no //keine korektur in der Email
        field.returnKeyType = .done
        field.autocapitalizationType = .none //keine Großschreibung beachten
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field .placeholder = "Passwort..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0)) //Abstand im textfield damit der text nicht direkt am Rand ist
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true //Passwort verdeckt
        return field
    }()
    
    
    private let loginButton: UIButton = { //Login Button Erstellt
        let button = UIButton()
        
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    private let facebookLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "log In"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",style: .done,target: self,action: #selector (didTapRegister)) //die func wird aufgerufen //Button oben Rechts hinuzgefügt zum registrieren
     
        
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside) //LoginButton Funktion eingefügt
        emailField.delegate = self
        passwordField.delegate = self
        facebookLoginButton.delegate = self
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView) //Bild wird im View eingefügt
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)

        
    }
    
    override func viewDidLayoutSubviews() { //hier werden die Objekte wie Image oder Textfield deren Größe/Abstand eingestellt
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds //scrollView füllt den ganzen Bildschirm
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (view.width-size)/2, y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52) //y achse ist von dem imageView von der unteresen Seite 10 px entfernt
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        loginButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        facebookLoginButton.frame = CGRect(x: 30, y: loginButton.bottom+10, width: scrollView.width-60, height: 52)
        facebookLoginButton.frame.origin.y = loginButton.bottom+20
        
        
        
        
    }
    
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, //Variablen verteilung an EmailField und passwortfield
              !email.isEmpty, !password.isEmpty, password.count  >= 6 else { //wenn nichts drin ist und die Zahl kleiner 6 ist dann erscheint die Anzeige alterUserLogin
            alertUserLoginError()
            return
        
        }
        spinner.show(in: view)
        // Firebase Log In
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in //authresult und error in sind mögliche "Variabel die aufgerufen werden nachdem die Funktion aufgerufen wurde
            guard let strongSelf = self else {
                
                return
            }
                
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
          
            
        guard let result = authResult, error == nil else {
            print("Failed to log in user with email: \(email)")
            return
        }
        
        let user = result.user
        UserDefaults.standard.set(email, forKey: "email")
            //print("Ergebnis: \(UserDefaults.standard.mutableSetValue(forKey: "email"))")
        
        print("logged in User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil) //Viewcontroller schließt sich 
    })
    }
    
    
    
    
    
    func alertUserLoginError(message: String = "Bitte geben Sie alle Information an um einen neuen Account zu erstellen") {
        let alert = UIAlertController(title: "Ups", message: message , preferredStyle: .alert) //Titel und Text in der Fehleranzeige
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil)) //Die "Wegdrücken" Taste
        present(alert, animated: true)        }
    
    
    
    @objc private func didTapRegister() {  //wird aufgerufen wenn die Taste registrieren hinzugefügt wird
        let vc = RegisterViewController()   //ViewController RegisterViewController wird aufgerufen
        vc.title = "Create Account" //Title oben in der Mitte
        navigationController?.pushViewController(vc, animated: true) //für den Push/Swipe Effekt 
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()  //wenn auf weiter gedrückt wird dann kommt man direkt zum Passwort Feld 
            
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}


extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) { //unwrap token von facebook
        guard let token = result?.token?.tokenString else {
            
            print("user failed to log in with facebook")
            return
            
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"], tokenString: token, version: nil, httpMethod: .get) // Email und name werden von facebook geholt
        
        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String: Any], error == nil else {
               // print("failed to make facebook graph request ")
                return //Request wird ausgeführt und die Daten werden auf die App geholt
            }
            
            print("\(result)") //in Result sind die Daten die übergeben werden
            
        
            //die Daten werden alle aus result und pictureund data geholt die in GraphRequest geholt werden
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any?],
                  let data = picture["data"] as? [String: Any?],
                  let pictureUrl = data["url"] as? String
            else {
                print("failed to get email and name from fb ")
                return  // Daten werden unwrapped
            }
            
            
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                //email wird überprüft ob sie bereits existiert
                
                if !exists {
                    let chatUser = DatabaseManager.ChatAppUser(firstName: firstName, lastName: lastName, emailAdress: email)
                        //ChatAppUser(firstName: firstName, lastName: lastName, emailAdress: email) , DatabaseManager hinzugefügt
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { succes in
                        if succes {
                            
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            
                            print("Downloading data from facebook image")
                            
                            URLSession.shared.dataTask(with: url, completionHandler: {data, _,_ in
                                guard let data = data else {
                                    print("failed to get data from fb")
                                    return
                                }
                                
                                print("got data from FB, uploading")
                                
                                let filename = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                    switch result{
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")

                                    }
                                    } )
                                    
                                    
                                    
                                    //upload image
                                
                                
                            }).resume()
                        }
                    })
                }
                
                
            })
            
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token) //Token von Facebook wird getauscht mit dem credentiel token von uns
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    print("irgendetwas stimmt wohl nicht")
                    return
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("facebook credential login failed - \(error)")
                    }
                    
                    return
                }
                print("succesfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil) //Viewcontroller schließt sich
                
            })
        })
        
        
        
        
      
    }

    
}
