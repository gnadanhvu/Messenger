//
//  Extension.swift
//  Messenger
//
//  Created by Vu Dang Anh on 15.03.21.
//

import Foundation
import UIKit
//zum Einsparen von den Codes für die Objekte wie Images
extension UIView {
    public var width: CGFloat{ //statt width = self.frame.size.width
        return self.frame.size.width
    }
    
    public var height: CGFloat{
        return self.frame.size.height
    }
    
    public var top: CGFloat{
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat{
        return self.frame.origin.x
    }
    
    public var right: CGFloat{
        return self.frame.size.width + self.frame.origin.x
    }
}
