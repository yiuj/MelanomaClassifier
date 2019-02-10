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
//import Firebase
//import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchMelanomaImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeAPICall() {
        
        let targetURL = URL(string: "http://127.0.0.1:5000/")
        let request = NSURLRequest(URL: targetURL) //this is the line with error.
        webView.loadRequest(request)
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
                print(receivedTodo)
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

