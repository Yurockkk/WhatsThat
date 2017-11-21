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
        var urlComponents = URLComponents(string: "https://vision.googleapis.com/v1/images:annotate")!
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "AIzaSyChQzplbC-Le2qLiB9DCc4n2oIdi97Usvk")
        ]
        
//        let jsonBody: [String: Any] = [
//            "requests": [
//                {
//                    "image": {
//
//                    },
//                    "features": {
//
//                    }
//                }
//                ]
//            ]
        delegate?.resultFound(results: ["cat","hard-coded","Dog"])
    }
}

//post request from Postman

//{
//    "requests": [
//        {
//            "image": {
//                "source": {
//                    "imageUri": "https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=333&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%20333w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=633&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%20633w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=666&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%20666w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=933&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%20933w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=1233&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%201233w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=1266&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%201266w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=1533&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%201533w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=1833&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%201833w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=1866&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%201866w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=2133&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%202133w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=2433&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%202433w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=2466&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%202466w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=2733&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%202733w,%20https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?auto=format&fit=crop&w=2848&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D%202848w"
//                }
//            },
//            "features": [
//                {
//                    "type": "LABEL_DETECTION",
//                    "maxResults": 10
//                }
//            ]
//    
//        }
//    ]
//}

