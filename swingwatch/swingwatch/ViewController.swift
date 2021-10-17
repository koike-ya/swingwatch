//
//  ViewController.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private var watchConnector: WatchConnector?

    @IBOutlet weak var watchMessageLabel: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        watchConnector = WatchConnector(self)
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("error", error)
                self.errorLabel.text = error.localizedDescription
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let fileUrl = info[.mediaURL] else { return }
        CloudStorage.uploadVideoToGCS(fileUrl as! URL) { error in
            if let error = error {
                self.errorLabel.text = error
            }
        }
    }
}

extension ViewController: WatchConnectorDelegate {
    
    func didReceiveMessage(message: String) {
        DispatchQueue.main.async {
            self.watchMessageLabel.text = message
        }
    }
    
    func didReceiveFile(url: URL) {
        CloudStorage.uploadMotionToGCS(url) { error in
            if let error = error {
                self.errorLabel.text = error
            }
        }
    }
}
