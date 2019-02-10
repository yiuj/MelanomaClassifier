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
import FirebaseDatabase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imagePicked: UIImageView!
    
    var ref: DatabaseReference!
//    var ref: DatabaseReference! = Database.database().reference()
//
//    var allKevins = [DataSnapshot]()
    var array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //fetchMelanomaImage()
        // Listen for new comments in the Firebase database
        
//        ref = Database.database().reference()
//        var kevinsRef = ref.child("kevins")
//        print("HEELELLELLLELLEOOOOOO: " + kevinsRef.toString())
//        kevinsRef.observe(.childAdded, with: { (snapshot) -> Void in
//            print(snapshot.value)
//        })
        getData()
    }
    
    func getData() {
        print("GETTING DATAAAAAAAAAAAAAAA")
        let kevinsRef = Database.database().reference().child("kevins")
//        let query = kevinsRef.queryOrdered(byChild: "cost").queryEqual(toValue: "low" )
        kevinsRef.observe(.value, with: {(snapshot) in
            for child in snapshot.children {
                if child is DataSnapshot {
                    let id = (((child as! DataSnapshot).value!) as! NSDictionary)["id"]!
                    let results = (((child as! DataSnapshot).value!) as! NSDictionary)["results"]!
                    print(id)
                    print(results)
                }
                else {
                    print("NOT A DATA SNAPSHOT")
                }
            }
//            self.array.append((snapshot.childSnapshot(forPath: "kevins").value as? String)!)
//            print("Printing arrayyyyyyyyyyy")
//            print(self.array)
        }) { (error) in
            print(error)
            
        }
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

