//
//  PhotoIdentificationViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/19/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class PhotoIdentificationViewController: UIViewController {
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedImage != nil{
            print("we got selected image!")
        }else{
            print("we didn't get selected image!")

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
