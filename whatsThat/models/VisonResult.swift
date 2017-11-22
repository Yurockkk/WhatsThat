//
//  VisonResult.swift
//  whatsThat
//
//  Created by Yubo on 11/21/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation


struct Root: Codable {
    
    let responses: [Responses]
    
}

struct Responses: Codable {
    
    let labelAnnotations: [LabelAnnotations]
    
}

struct LabelAnnotations: Codable {
    
    let mid: String
    let description: String
    let score: Double
    
}
