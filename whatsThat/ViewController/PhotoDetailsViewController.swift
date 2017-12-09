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
    //for favorite feature
    var selectedImage: UIImage?
    var wikiBaseUrl = "https://en.wikipedia.org/"
    var wikiId:String?
    let favImage = #imageLiteral(resourceName: "fav")
    let unFavImage = #imageLiteral(resourceName: "unfav")
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.selectedDescription)
        WikipediaAPIManager.sharedInstance.delegate = self
        if let selectedTitle = selectedTitle{
            self.title = selectedTitle
            WikipediaAPIManager.sharedInstance.fetchWikiData(queryString: selectedTitle)
            //start progress bar
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        // Do any additional setup after loading the view.
        
        //create favorite btn
        let favBtn = UIBarButtonItem(image: unFavImage, style: .plain, target: self, action: #selector(faveBtnPressed(sender:)))
        self.navigationItem.rightBarButtonItem = favBtn
       
        
    }
    
    @objc func faveBtnPressed(sender: UIBarButtonItem){
        print("faveBtnPressed, user wanna fave \(selectedTitle)")
    }
    
    @IBAction func wikiBtnPressed(_ sender: UIButton) {
        let url = wikiBaseUrl + "?curid=" + self.wikiId!
        let sVC = SFSafariViewController(url: URL(string: url)!)
        self.present(sVC, animated: true, completion: nil)
    }
    
    @IBAction func tweetBtnPressed(_ sender: UIButton) {
//        let tVC = ListTimelineViewController()
        self.performSegue(withIdentifier: "showTwitterList", sender: self)
//        self.present(tVC, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        //create text to share
        if let titleToShare = self.title {
            let textToShare = [titleToShare]
            //create a activityViewController
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            //present the activityViewController
            self.present(activityViewController, animated: true, completion: nil)
            
        }

    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTwitterList" {
            print("in prepare")
            let destVC = segue.destination as? ListTimelineViewController
            
            destVC?.queryText = self.selectedTitle
            
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
