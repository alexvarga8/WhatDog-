//
//  ViewController.swift
//  WhatDog!
//
//  Created by Alex Varga on 08/06/2019.
//  Copyright © 2019 Alex Varga. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.originalImage] as? UIImage {
            
            imageView.image = pickedImage
            
            guard let ciimage = CIImage(image: pickedImage) else {
                fatalError("...")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: dog_classifier().model) else {
            fatalError("...")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("...")
            }
            
            self.navigationItem.title = classification.identifier.capitalized
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        }
        catch {
            
            print(error)
        }
        
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

