//
//  ListTimelineViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/25/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import TwitterKit

class ListTimelineViewController: TWTRTimelineViewController {
    var queryText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In ListTimelineViewController")
        
        if let queryText = queryText{

            self.dataSource = TWTRSearchTimelineDataSource(searchQuery: queryText, apiClient: TWTRAPIClient())
            
        }
        
    }


}
