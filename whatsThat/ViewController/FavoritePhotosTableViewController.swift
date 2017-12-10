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
    var selectedImageFileName:String?
    var favorites:[Favorite]!
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        print("FavoritePhotosTableViewController: viewDidLoad")

        
    }
    
    func getImage(imageFileName:String) -> UIImage?{
        var imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageFileName)
        imagePath = "\(imagePath).jpg"
        print(imagePath)

        return UIImage(contentsOfFile: imagePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FavoritePhotosTableViewController: viewWillAppear")
        self.favorites = PersistanceManager.sharedInstancec.fetchFavorites()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        //let defaultFavImage = #imageLiteral(resourceName: "fav")
        let favImage = getImage(imageFileName: favorites[indexPath.row].imageName)
        // Configure the cell...
        cell.favTitle.text = favorites[indexPath.row].title
        cell.favImageView.image = favImage
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("user click \(indexPath.row)")
        self.selectedIdentification = favorites[indexPath.row].title
        self.selectedImageFileName = favorites[indexPath.row].imageName
        performSegue(withIdentifier: "favToDetailed", sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favToDetailed" {
            print("in prepare")
            let destVC = segue.destination as? PhotoDetailsViewController
            destVC?.isFromFav = true
            destVC?.selectedTitle = self.selectedIdentification
            destVC?.selectedImageFileName = self.selectedImageFileName
        }
    }
    

}
