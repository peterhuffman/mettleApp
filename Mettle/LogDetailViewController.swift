//
//  LogDetailViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var type: DetailType = .new
    var callback: ((Date, String, [Float], Data)->Void)?
    var dateSelected: Date!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var hsSlider: UISlider!
    @IBOutlet weak var rsSlider: UISlider!
    @IBOutlet weak var pgSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            imageView.image = UIImage(named: "default")
            break
        case let .update(date, text, values, image):
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            navigationItem.title = dateFormatter.string(from: date)
            datePicker.date = date
            entryText.text = text
            hsSlider.value = values[0]
            pgSlider.value = values[1]
            rsSlider.value = values[2]
            imageView.image = UIImage(data: image as Data)
        }
        
    }
    
    
    @IBAction func imageButton(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            // Add code here after image is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        let date = datePicker.date 
        let text = entryText.text ?? ""
        let values = [hsSlider.value, pgSlider.value, rsSlider.value]
        let image = UIImagePNGRepresentation(imageView.image!)!

        if callback != nil{
            callback!(date, text, values, image)
        }
    }
    
    
}


enum DetailType{
    case new
    case update(Date, String, [Float], Data)
}
