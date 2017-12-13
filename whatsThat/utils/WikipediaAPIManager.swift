//
//  WikipediaAPIManager.swift
//  whatsThat
//
//  Created by Yubo on 11/23/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

protocol WikipediaAPIDelegate {
    func resultFound(results: [String?])
    func resultNotFound()
}

class WikipediaAPIManager {
    var delegate: WikipediaAPIDelegate?
    static let sharedInstance = WikipediaAPIManager()
    
    func fetchWikiData(queryString:String){
        print("fetching wiki data for \(queryString)")
        //base url
        var urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php")!
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "extracts"),
            URLQueryItem(name: "exintro", value: ""),
            URLQueryItem(name: "explaintext", value: ""),
            URLQueryItem(name: "titles", value: queryString)
        ]

        let url = urlComponents.url!
        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //check for valid response with 200
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self.delegate?.resultNotFound()
                return
            }
            guard let data = data else{
                self.delegate?.resultNotFound()
                return
            }
            //TODO: use codable to parse JSON
            
            guard let parsedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [String:Any]() else{
                self.delegate?.resultNotFound()
                return
            }
            
            guard let queryJsonObject = parsedData["query"] as? [String:Any] else{
                self.delegate?.resultNotFound()
                return
            }
            
            guard let pagesObject = queryJsonObject["pages"] as? [String:Any] else{
                self.delegate?.resultNotFound()
                return
            }
            var pageId:String?
            var finalObj:[String:Any]?
            for (key,value) in pagesObject{
                pageId = key
                finalObj = value as? [String:Any] ?? [String:Any]()
            }
            
            guard let wikiExtract = finalObj!["extract"] as? String? ?? "" else{
                self.delegate?.resultNotFound()
                return
            }
            
            guard let id = pageId else{
                self.delegate?.resultNotFound()
                return
            }
            var dataToPass = [String?]()
            dataToPass.append(id)
            dataToPass.append(wikiExtract)
    
            self.delegate?.resultFound(results: dataToPass)
            
        }
        task.resume()
    }
}
