//
//  PersistanceManager.swift
//  whatsThat
//
//  Created by Yubo on 12/9/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

class PersistanceManager{
    static let sharedInstancec = PersistanceManager()
    let favoritesKey = "favorites"
    
    func fetchFavorites() -> [Favorite]{
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: favoritesKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Favorite] ?? [Favorite]()
        }else{
            //data is nil
            return [Favorite]()
        }
        
    }
    
    func saveFavorite(_ favorite: Favorite){
        let userDefaults = UserDefaults.standard
        var favorites = fetchFavorites()
        favorites.append(favorite)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: favorites)
        
        userDefaults.set(data, forKey: favoritesKey)
    }
    
}
