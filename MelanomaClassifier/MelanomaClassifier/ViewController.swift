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

    @IBOutlet weak var imageView: UIImageView!
    
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
        let todosEndpoint: String = "http://127.0.0.1:5000/"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let newTodo: [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print(receivedTodo)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        // Infinitely run the main loop to wait for our request.
        // Only necessary if you are testing in the command line.
        RunLoop.main.run()
    }
}
