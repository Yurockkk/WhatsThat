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
    var mapBtn:UIBarButtonItem?
    let navigationImage:UIImage = #imageLiteral(resourceName: "navigation")


    override func viewDidLoad() {
        super.viewDidLoad()
        print("FavoritePhotosTableViewController: viewDidLoad")
        
        //create map btn
        mapBtn = UIBarButtonItem(image: navigationImage, style: .plain, target: self, action: #selector(mapBtnPressed(sender:)))
        self.navigationItem.rightBarButtonItem = mapBtn
    }
    
    @objc func mapBtnPressed(sender: UIBarButtonItem){
        print("mapBtnPressed")
        self.performSegue(withIdentifier: "showMapSegue", sender: self)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favToDetailed" {
            print("in prepare")
            let destVC = segue.destination as? PhotoDetailsViewController
            destVC?.selectedTitle = self.selectedIdentification
            destVC?.selectedImageFileName = self.selectedImageFileName
        }
    }
    
}
