//
//  StorageManager.swift
//  Messenger
//
//  Created by Vu Dang Anh on 22.03.21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    
        
    
    
    
    public typealias UploadPictureCompletion = (Result <String, Error>) -> Void //wenn es Result eine Datei erhält dann entweder ein String oder ein Error
    
    
    ///Upload picture to fireBase storage and returns completion with url to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion)  {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("failed to get downlaod URL")
                    
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url return: \(urlString)")
                completion(.success(urlString))

            })
            
        })
     
    
    }
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping(Result<URL, Error>) -> Void ){ //Result wird sein ein URL oder Error
        let reference = storage.child(path)
        
        reference.downloadURL(completion: {url, error in
            
            
            guard let url = url, error == nil else {
              
               
                completion(.failure(StorageErrors.failedToGetDownloadURL))
              
                return
            }
            completion(.success(url))
        
        })
    }
}
