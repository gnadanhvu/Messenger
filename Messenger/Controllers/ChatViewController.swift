//
//  ChatViewController.swift
//  Messenger
//
//  Created by Vu Dang Anh on 21.03.21.
//

import UIKit
import MessageKit


struct  Message: MessageType{ //Empfänger
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}


struct Sender: SenderType{
    var photoURL: String
    var senderId: String
    var displayName: String
    
    
    
}




class ChatViewController: MessagesViewController {
    
    private var message = [Message]()
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind:  .text("hello world")))
        message.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind:  .text("hello world asd sdfsfgdsyfgdfgdfg")))

        
        
        
        
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self //Protokolle der
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

  
    }
    
    


}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType { //entscheidet die Seite also Empfänger oder Sender
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return message[indexPath.section] 
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return message.count
    }
    
    
}
