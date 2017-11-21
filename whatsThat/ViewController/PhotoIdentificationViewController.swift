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
    var results = [String]()

    var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedImage != nil{
            print("we got selected image!")
            imageView.image = selectedImage
            GoogleVisionAPIManager.sharedInstance.delegate = self
            guard let imageData = UIImagePNGRepresentation(selectedImage!) else{
                print("converting to base64 went wrong")
                return
            }
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            GoogleVisionAPIManager.sharedInstance.fetchIdentificationList(baseString: strBase64)
        }else{
            print("we didn't get selected image!")

        }
        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MBProgressHUD.hide(for: self.view, animated: true)
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

//adhere to the NearbyGymDelegate protocol
extension PhotoIdentificationViewController: GoogleVisionAPIDelegate {
    func resultFound(results: [String]) {
        self.results = results
        print("found results from Google Vision API")
        print("\(results)")

        //update tableview data on the main (UI) thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //self.tableView.reloadData()
        }
    }
    
    func resultNotFound() {
        print("no results :(")

    }
}
