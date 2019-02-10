//
//  ViewController.swift
//  MelanomaClassifier
//
//  Created by Jonathan Yiu on 2/9/19.
//  Copyright © 2019 yiuj. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import MobileCoreServices
import Photos
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imagePicked: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //fetchMelanomaImage()
        
        
        
        let uuid = UUID().uuidString
        NSLog(uuid)
        
        FirebaseApp.configure()
        let storage = Storage.storage(url:"gs://skincheck-6d167.appspot.com")
        let storageRef = storage.reference()
        
        // Points to "images"
        let imagesRef = storageRef.child("images")
        
        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = "faf701c4-f917-4ba3-95ad-9b17a24bf4d8.jpg"
        let sausageRef = imagesRef.child(fileName)
        
        // File path is "images/space.jpg"
        let path = sausageRef.fullPath;
        
        // File name is "space.jpg"
        let name = sausageRef.name;
        
        // Points to "images"
        let images = sausageRef.parent()
        
        
    }

    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMelanomaImage(){
        let url = URL(string: "") // change this URL
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        task.resume()
        
        // Infinitely run the main loop to wait for our request.
        // Only necessary if you are testing in the command line.
        RunLoop.main.run()
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBAction func selectPhoto(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            // after it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImageView.image = image
        }
        else{
            // Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

