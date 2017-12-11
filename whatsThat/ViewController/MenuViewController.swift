//
//  MenuViewController.swift
//  whatsThat
//
//  Created by Yubo on 11/15/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    

    @IBOutlet weak var cameraBtn: UIButton!
    @IBAction func cameraBtn(_ sender: UIButton) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in viewDidLoad")
        
        imagePicker.delegate = self

    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            
            print(" have camera")
            //check & handle permission status
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            switch cameraAuthorizationStatus {
                
            case .authorized:
                // Access is granted by user.
                print("user authorized")
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                break
                
            case .notDetermined:
                // It is not determined until now.
                print("user notDetermined")
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                break
                
            case .restricted:
                // User do not have access to camera.
                print("user restricted")
                break
                
            case .denied:
                // User has denied the permission.
                print("user denied")
                let alert = UIAlertController(title: "Go to setting and allow us to use camera to capture picture!", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                break
            }

        }else{
            print("dont have camera")
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoIdentificationSegue" {
            print("in prepare")
            let destinationViewController = segue.destination as? PhotoIdentificationViewController

            destinationViewController?.selectedImage = image
        }
    }

}

extension MenuViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        view.alpha = 1;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            print("we got editImage")
            image = editImage
            //perform segue to PhotoIdentificationViewController
            self.performSegue(withIdentifier: "PhotoIdentificationSegue", sender: self)

        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("we got originalImage")
            image = originalImage
            //perform segue to PhotoIdentificationViewController
            self.performSegue(withIdentifier: "PhotoIdentificationSegue", sender: self)

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
