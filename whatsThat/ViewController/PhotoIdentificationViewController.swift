//
//  PhotoIdentificationViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/19/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import MBProgressHUD


class PhotoIdentificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var results = [String]()
    var selectedIdentification: String?

    var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //start progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        handleSelectedImage()
        
    }
    
    func handleSelectedImage(){
        if selectedImage != nil{
            print("we got selected image!")
            imageView.image = selectedImage
            GoogleVisionAPIManager.sharedInstance.delegate = self
            guard let imageData = UIImagePNGRepresentation(selectedImage!) else{
                print("converting to base64 went wrong")
                return
            }
            //if we have internet access than fetchIdentificationList from Google API
            if(Reachability.isConnectedToNetwork()){
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                GoogleVisionAPIManager.sharedInstance.fetchIdentificationList(baseString: strBase64)
            }else{
                print("we don't have network ability")
                //no internet access, stop spining
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                let alert = UIAlertController(title: "Please turn on your Wi-Fi or celular data and then try again!", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            print("we didn't get selected image!")
            //something wrong, stop spining
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "detailedDescription" {
            print("in prepare")
            let destVC = segue.destination as? PhotoDetailsViewController
            
            destVC?.selectedTitle = self.selectedIdentification
            destVC?.selectedImage = self.selectedImage
            
        }
    }
 

}

extension PhotoIdentificationViewController: GoogleVisionAPIDelegate {
    func resultFound(results: [String]) {
        self.results = results
        print("found results from Google Vision API")
        print("\(self.results)")
        
        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func resultNotFound() {
        print("no results :(")
        //ask user try again later
        let alert = UIAlertController(title: "We can't find any result at this time, please try again later", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }

    }
}

extension PhotoIdentificationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.results.count)
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "visionCell", for: indexPath)
        
        cell.textLabel?.text = self.results[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("user click \(indexPath.row)")
        self.selectedIdentification = self.results[indexPath.row]
        performSegue(withIdentifier: "detailedDescription", sender: self)
    }
    
    
}
