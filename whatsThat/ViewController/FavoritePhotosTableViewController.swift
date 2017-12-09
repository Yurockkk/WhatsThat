//
//  FavoritePhotosTableViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/28/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    
    var selectedIdentification: String?
    var favorites:[Favorite]!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FavoritePhotosTableViewController: viewDidLoad")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        favorites = PersistanceManager.sharedInstancec.fetchFavorites()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = favorites[indexPath.row].title

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("user click \(indexPath.row)")
        self.selectedIdentification = "yolo"
//        performSegue(withIdentifier: "detailedDescription", sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
        if segue.identifier == "detailedDescription" {
            print("in prepare")
            let destVC = segue.destination as? PhotoDetailsViewController
            
            destVC?.selectedTitle = self.selectedIdentification
            
        }
    }
    

}
