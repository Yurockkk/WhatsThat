//
//  Favorite.swift
//  whatsThat
//
//  Created by Yubo on 12/9/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

class Favorite: NSObject{
    let title: String
    let imageName: String
    
    let titleKey = "title"
    let imageNameKey = "imageName"
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as! String
        imageName = aDecoder.decodeObject(forKey: imageNameKey) as! String
    }
}

extension Favorite: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(imageName, forKey: imageNameKey)
        
    }
}
