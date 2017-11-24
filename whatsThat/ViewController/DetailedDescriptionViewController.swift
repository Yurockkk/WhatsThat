//
//  DetailedDescriptionViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/23/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailedDescriptionViewController: UIViewController {
    var selectedDescription: String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.selectedDescription)
        WikipediaAPIManager.sharedInstance.delegate = self
        if let selectedDescription = selectedDescription{
            WikipediaAPIManager.sharedInstance.fetchWikiData(queryString: selectedDescription)
            //start progress bar
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailedDescriptionViewController: WikipediaAPIDelegate{
    func resultFound(results: String) {
        print("we got wiki data: \(results)")
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //self.tableView.reloadData()
        }
    }
    
    func resultNotFound() {
        //update tableview data on the main (UI) thread
        print("we didn't get wiki data")

        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
}
