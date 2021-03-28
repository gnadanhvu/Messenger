//
//  DatabaseManagerFile.swift
//  Messenger
//
//  Created by Vu Dang Anh on 17.03.21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAdress: String) -> String {
        
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-") //nimmt die Konstante emailAdress, macht die replaces und dann gibt sie safeEmail zurück
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}


// MARK: - Account Management


extension DatabaseManager {
    
    
    
    public func userExists(with email: String, completion: @escaping ((Bool) ->Void))  {
        
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
 
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard  snapshot.value as? String != nil else { //wenn Snapchot Inhalt einen String enthält, ist eine Email vorhanden
                
                completion(false)
                
                return
            }
            
            
            completion(true)
        })
        
        
    }
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void ) {
    database.child(user.safeEmail).setValue(["first_name": user.firstName, "last_name": user.lastName], withCompletionBlock: { error, _ in
            guard error == nil else {
            print("failed to write to database")
                completion(false)
                return
            }
        
        
        
        
        self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            if var usersCollection = snapshot.value as? [[String: String]] {
                //append in unsere Bibliothek
                let newElement = [
                    "name": user.firstName + " " + user.lastName,
                    "email": user.safeEmail
                ]
                
           
                usersCollection.append(newElement)
                self.database.child("users").setValue(usersCollection, withCompletionBlock: {
                    error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                completion(true)
                })
                
                
                
            }
            else {
                // create array
                let newCollection: [[String: String]] = [
                    ["name": user.firstName,
                    "email": user.safeEmail ]
                ]
                self.database.child("users").setValue(newCollection, withCompletionBlock: {
                    error, _ in
                    guard error == nil else {
                        return
                    }
                    completion(true)
                })
            }
        })
        
    })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    struct ChatAppUser {
        let firstName: String
        let lastName: String
    let emailAdress: String
    
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-") //nimmt die Konstante emailAdress, macht die replaces und dann gibt sie safeEmail zurück
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    
    
}


}
