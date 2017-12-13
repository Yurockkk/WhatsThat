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
    let lon: Double?
    let lat: Double?
    
    let titleKey = "title"
    let imageNameKey = "imageName"
    let lonKey = "lonKey"
    let latKey = "latKey"
    
    
    init(title: String, imageName: String, lon: Double?, lat: Double?) {
        self.title = title
        self.imageName = imageName
        self.lon = lon
        self.lat = lat

    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as! String
        imageName = aDecoder.decodeObject(forKey: imageNameKey) as! String
        lon = aDecoder.decodeObject(forKey: lonKey) as? Double
        lat = aDecoder.decodeObject(forKey: latKey) as? Double
    }
}

extension Favorite: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(imageName, forKey: imageNameKey)
        aCoder.encode(lon, forKey: lonKey)
        aCoder.encode(lat, forKey: latKey)
    }
}
