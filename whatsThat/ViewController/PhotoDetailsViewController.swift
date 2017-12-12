//
//  PhotoDetailsViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/23/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import MBProgressHUD
import SafariServices


class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var wikiTextView: UITextView!
    var wikiExtract: String?
    var selectedTitle: String?
    var selectedImageFileName: String?
    //for favorite feature
    var selectedImage: UIImage?
    var wikiBaseUrl = "https://en.wikipedia.org/"
    var wikiId:String?
    var isFavorite: Bool = false {
        didSet{
            updateFavBtnUI()
        }
    }
    let favImage = #imageLiteral(resourceName: "fav")
    let unFavImage = #imageLiteral(resourceName: "unfav")
    var favBtn:UIBarButtonItem?
    let fileManager = FileManager.default
    let locationFinder = LocationFinder()
    var imageLon: Double?
    var imageLat: Double?


    override func viewDidLoad() {
        super.viewDidLoad()
        WikipediaAPIManager.sharedInstance.delegate = self
        locationFinder.delegate = self

        if let selectedTitle = selectedTitle{
            //start progress bar
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.title = selectedTitle
            if(Reachability.isConnectedToNetwork()){
                //Only call Wikipedia API if we got internet access
                WikipediaAPIManager.sharedInstance.fetchWikiData(queryString: selectedTitle)
                //get location for favorite
                locationFinder.findLocation()
            }else{
                print("we don't have network ability")
                //no internet access, stop spining and disable button click
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.wikiBtn.isEnabled = false
                    self.tweetBtn.isEnabled = false
                    self.shareBtn.isEnabled = false
                }
                let alert = UIAlertController(title: "Please turn on your Wi-Fi or celular data and then try again!", message: nil, preferredStyle: .alert)
                self.wikiTextView.text = "Please turn on your Wi-Fi or celular data and then try again!"
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        //create favorite btn
        favBtn = UIBarButtonItem(image: unFavImage, style: .plain, target: self, action: #selector(faveBtnPressed(sender:)))
        if isContainsInFavorites() {
            isFavorite = true
        }
        self.navigationItem.rightBarButtonItem = favBtn
    }
    
    @objc func faveBtnPressed(sender: UIBarButtonItem){
        if !isContainsInFavorites(){
            //we need to run through save favorite process (only first time)
            isFavorite = true
            let timestamp = String(NSDate().timeIntervalSince1970)
            print(timestamp)
            self.selectedImageFileName = timestamp
            if let favoriteTitle = selectedTitle {
//                let favorite = Favorite(title: favoriteTitle, imageName: timestamp,lon)
                let favorite = Favorite(title: favoriteTitle, imageName: timestamp, lon: imageLon, lat: imageLat)
                PersistanceManager.sharedInstancec.saveFavorite(favorite)
                saveImageDocumentDirectory(fileName: timestamp)
            }
            
           //debug
            PersistanceManager.sharedInstancec.fetchFavorites().forEach({ (fav) in
                print("title: \(fav.title), imageName: \(fav.imageName), lon: \(fav.lon), lat: \(fav.lat)")
            })
        }else{
            //toggle isFavorite
            isFavorite = !isFavorite
        }
        
    }
    
    func isContainsInFavorites() -> Bool{
        let favorites = PersistanceManager.sharedInstancec.fetchFavorites()
        for(_,fav) in favorites.enumerated(){
            if fav.title == self.selectedTitle{
                return true
            }
        }
        return false
    }
    
    func updateFavBtnUI(){
        DispatchQueue.main.async {
            if self.isFavorite {
                self.favBtn?.image = self.favImage
            }else{
                self.favBtn?.image = self.unFavImage
            }
        }
    }
    
    @IBOutlet weak var wikiBtn: UIButton!
    @IBAction func wikiBtnPressed(_ sender: UIButton) {
        let url = wikiBaseUrl + "?curid=" + self.wikiId!
        let sVC = SFSafariViewController(url: URL(string: url)!)
        self.present(sVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tweetBtn: UIButton!
    @IBAction func tweetBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showTwitterList", sender: self)
    }
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        //create text to share
        if let titleToShare = self.title {
            let textToShare = [titleToShare]
            //create a activityViewController
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            //present the activityViewController
            self.present(activityViewController, animated: true, completion: nil)
            
        }

    }

    func saveImageDocumentDirectory(fileName:String){
        var imageFileName = fileName
        imageFileName = "\(imageFileName).jpg"
        print("imageFileName: \(imageFileName)")
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageFileName)
        let image = selectedImage
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths, contents: imageData, attributes: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTwitterList" {
            print("in prepare")
            let destVC = segue.destination as? ListTimelineViewController
            
            destVC?.queryText = self.selectedTitle
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("in viewWillDisappear" )
        if !isFavorite{
            let favorites = PersistanceManager.sharedInstancec.fetchFavorites()
            for(index, fav) in favorites.enumerated(){
                //debug
//                print("fav.title: \(fav.title), self.selectedTitle: \(self.selectedTitle)")
//                print("fav.imageName: \(fav.imageName), self.selectedImageFileName: \(self.selectedImageFileName)")
                
                if(fav.title == self.selectedTitle){
                    print("unfavorite item")
                    PersistanceManager.sharedInstancec.removeFavorite(index: index)
                }
            }
        }
    }
}

extension PhotoDetailsViewController: WikipediaAPIDelegate{
    func resultFound(results: [String?]) {
        print("we got wiki data")
        
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            if let id = results[0],let wikiExtract = results[1]{
                self.wikiId = id
                self.wikiTextView.text = wikiExtract
            }
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

//adhere to the LocationFinderDelegate protocol
extension PhotoDetailsViewController: LocationFinderDelegate {
    func locationFound(latitude: Double, longitude: Double) {
//        fetchGyms(latitude: latitude, longitude: longitude)
        print("we get location data, lon: \(longitude), lat: \(latitude)")
        
        imageLon = longitude
        imageLat = latitude
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //TODO pop up an alert controller with message
            
        }
    }
    
    func locationNotFound(reason: LocationFinder.FailureReason) {
        print("we didn't get location data")
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //TODO pop up an alert controller with message
            print(reason.rawValue)
            
        }
    }
}
