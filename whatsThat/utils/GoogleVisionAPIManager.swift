//
//  GoogleVisionAPIManager.swift
//  whatsThat
//
//  Created by Yubo on 11/20/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

protocol GoogleVisionAPIDelegate {
    func resultFound(results: [String])
    func resultNotFound()
}

class GoogleVisionAPIManager{
    var delegate: GoogleVisionAPIDelegate?
    static let sharedInstance = GoogleVisionAPIManager()

    func fetchIdentificationList(baseString: String){
        print("fetching...")
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
        ]
        
        let parameters = ["requests": [
            [
                "image": ["content": baseString],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
            ]] as [String : Any]
        
        let postData = try?JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyChQzplbC-Le2qLiB9DCc4n2oIdi97Usvk")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
             //check for valid response with 200
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self.delegate?.resultNotFound()
                return
            }
            
            guard let data = data else{
                self.delegate?.resultNotFound()
                return
            }
            
            let decoder = JSONDecoder()
            let rootData = try? decoder.decode(Root.self,from: data)
            
            guard let root = rootData else{
                self.delegate?.resultNotFound()
                return
            }
            let responses = root.responses
            var result = [String]()
            for labelAnnotation in responses[0].labelAnnotations {
                result.append(labelAnnotation.description)

            }
            self.delegate?.resultFound(results: result)
        })
        task.resume()
    }
}


