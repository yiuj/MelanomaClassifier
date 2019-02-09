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

class ViewController: UIViewController{
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        /*do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            captureSession?.startRunning()
        } catch {
            print(error)
        }*/
        fetchMelanomaImage()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMelanomaImage(){
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY") // change this URL
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
            }
        }
        task.resume()
        
        // Infinitely run the main loop to wait for our request.
        // Only necessary if you are testing in the command line.
        RunLoop.main.run()
    }
}
