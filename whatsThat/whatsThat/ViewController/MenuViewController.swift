//
//  MenuViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/15/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    let imagePicker = UIImagePickerController()

    @IBAction func cameraBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            print("we have permission to camera")
            
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.delegate = self
            imagePicker.popoverPresentationController?.sourceView = view
            view.alpha = 0.5
            present(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //image picker
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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

extension MenuViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        view.alpha = 1;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            print("we got editImage")
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("we got originalImage")

        }
        picker.dismiss(animated: true)
        view.alpha = 1;
    }
}

extension MenuViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view.alpha = 1;
    }
}
