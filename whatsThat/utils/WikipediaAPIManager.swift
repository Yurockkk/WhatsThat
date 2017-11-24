//
//  WikipediaAPIManager.swift
//  whatsThat
//
//  Created by Yubo on 11/23/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

protocol WikipediaAPIDelegate {
    func resultFound(results: String)
    func resultNotFound()
}

class WikipediaAPIManager {
    var delegate: WikipediaAPIDelegate?
    static let sharedInstance = WikipediaAPIManager()
    
    func fetchWikiData(queryString:String){
        print("fetching wiki data")
        self.delegate?.resultFound(results: "QQQ")
    }
}
