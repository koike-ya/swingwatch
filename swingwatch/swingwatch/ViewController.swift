//
//  ViewController.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func startCamera(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.mediaTypes = ["public.movie"]
            cameraPicker.videoQuality = .typeHigh
            
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("SourceType.camera is not available.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let fileUrl = info[.mediaURL] else { return }
        uploadToGCS(fileUrl as! URL)
    }
    
    func uploadToGCS(_ fileUrl: URL) {
        print("fileUrl", fileUrl)
        let storageRef = CloudStorage.storageRef()
        let fileName = Date().toYYYYMMddHHmmssNoDelimiterString()
        let _ = storageRef.child("\(fileName).MOV").putFile(from: fileUrl, metadata: nil) { metadata, error in
            if let error = error {
                self.errorLabel.text = error.localizedDescription
            } else {
                print(metadata)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("error", error)
                self.errorLabel.text = error.localizedDescription
            }
        }
    }
}
