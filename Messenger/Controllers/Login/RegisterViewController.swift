//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Vu Dang Anh on 15.03.21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(systemName: "person.circle")  //Bild holen
        ImageView.tintColor = .gray
        ImageView.contentMode = .scaleAspectFit
        ImageView.layer.masksToBounds = true
        ImageView.layer.borderWidth = 2 // gibt dem Bild ein Rand 
        ImageView.layer.borderColor = UIColor.lightGray.cgColor //  gibt dem Rand eine Farbe
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
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no //keine korektur in der Email
        field.returnKeyType = .continue
        field.autocapitalizationType = .none //keine Großschreibung beachten
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field .placeholder = "Nachname..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0)) //Abstand im textfield damit der text nicht direkt am Rand ist
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no //keine korektur in der Email
        field.returnKeyType = .continue
        field.autocapitalizationType = .none //keine Großschreibung beachten
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field .placeholder = "Vorname..."
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
    
   

    
    private let registerButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "log In"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", //Button oben Rechts hinuzgefügt zum registrieren
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector (didTapRegister)) //die func wird aufgerufen
     
        
        
        registerButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView) //Bild wird im View eingefügt
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(firstNameField)
        
        imageView.isUserInteractionEnabled = true //ermöglicht das drauf Klicken auf das Bild
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic)) //Konstante Gesture Erstellen
        imageView.addGestureRecognizer(gesture) //die Konstante dem Bild zuordnen

        

    
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    override func viewDidLayoutSubviews() { //hier werden die Objekte wie Image oder Textfield deren Größe/Abstand eingestellt
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds //scrollView füllt den ganzen Bildschirm
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (view.width-size)/2, y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0 // macht das Bild Rund
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52) //y achse ist von dem imageView von der unteresen Seite 10 px entfernt
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom+10, width: scrollView.width-60, height: 52)
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom+10, width: scrollView.width-60, height: 52)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        
        guard let lastName = lastNameField.text,
              let firstName = firstNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
                    
        password.count  >= 6 else {
            alertUserRegisterError()
            return
        
        }
        spinner.show(in: view)
        //Firebase Log In
                DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner
                    .dismiss()
            }
    
            guard !exists else {
                strongSelf.alertUserRegisterError(message: "ein Account mit dieser email existiert bereits")
            
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {  authResult, error in

                guard authResult != nil, error == nil else { //bei Fehlermeldung
                    print("Fehlerbeim erstellen eines Profils")
                    return
                }
                
                let chatUser = DatabaseManager.ChatAppUser(firstName: firstName, lastName: lastName, emailAdress: email)
                    //ChatAppUser(firstName: firstName, lastName: lastName, emailAdress: email) ,DatabaseManager hinzugefügt
                
                DatabaseManager.shared.insertUser(with: chatUser, completion: { succes in
                    if succes {
                        //upload Image
                        guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                            return
                        }
                        let filename = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                            switch result{
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage manager error: \(error)")
                        
                        
                            }
                            
                        })
                    }
                })
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil) //Viewcontroller schließt sich

            
            })
            
            })
    
      
    
    }
    
    func alertUserRegisterError(message: String = "Bitte geben Sie alle Information an um einen neuen Account anzulegen") {
            let alert = UIAlertController(title: "Ups", message: message , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)        }
        
    
    
    @objc private func didTapRegister() {  //wird aufgerufen wenn die Taste registrieren hinzugefügt wird
        let vc = RegisterViewController()   //ViewController RegisterViewController wird aufgerufen
        vc.title = "Create Account" //Title oben in der Mitte
        navigationController?.pushViewController(vc, animated: true) //für den Push/Swipe Effekt
    }

}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
            
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func presentPhotoActionSheet() { // wird aufgerufen wenn das Bild gedruckt wird
        let actionSheet = UIAlertController(title: "Profilbild", message: "Wie willst du dein Bild auswählen", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "abbrechen", style: .cancel, handler: nil)) //cancel kann ses nur einmal geben
        actionSheet.addAction(UIAlertAction(title: "Foto machen", style: .default, handler: { [weak self] _ in self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Foto auswählen", style: .default, handler: { [weak self] _ in self?.presentPhotoPicker()
        }))
        
        
        present(actionSheet, animated: true)
    }

    func presentCamera (){ //wird aufgerufen durch das draufklicken bei Actionsheet
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentPhotoPicker (){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary //holt das Bild aus der Bibliothek
        vc.allowsEditing = true //erlaubt das Editieren des Bild
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //wenn man in Biblio ist kann man auf abbrechen
     
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image =  selectedImage //Bild was ausgewählt wird, wird eingefügt
    }
}

