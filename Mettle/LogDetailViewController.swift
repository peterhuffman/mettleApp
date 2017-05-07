//
//  LogDetailViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var type: DetailType = .new
    var callback: ((Date, String, [Float], String) -> Void)?
    var dateSelected: Date!
    var imageSelected: String?

    // UI Elements
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton1: UIButton!
    @IBOutlet weak var cameraButton2: UIButton!
    @IBOutlet weak var libraryButton1: UIButton!
    @IBOutlet weak var libraryButton2: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hsSlider: UISlider!
    @IBOutlet weak var psSlider: UISlider!
    @IBOutlet weak var cuSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    // Image Picker Elements
    let picker = UIImagePickerController()
    
    // Select photo from the user's library
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .popover
        present(picker, animated: true)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    @IBAction func deletePhoto(_ sender: UIButton) {
        imageView.image = nil
        deleteButton.isEnabled = false
        deleteButton.isHidden = true
        cameraButton1.isHidden = false
        cameraButton2.isHidden = false
        libraryButton1.isHidden = false
        libraryButton2.isHidden = false
        cameraButton1.isEnabled = true
        cameraButton2.isEnabled = true
        libraryButton1.isEnabled = true
        libraryButton2.isEnabled = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegates
        picker.delegate = self
        textView.delegate = self
        dateTextField.delegate = self
        dateSelected = Date()
        
        switch(type){
        case .new:
            imageSelected = UUID().uuidString
            textView.textColor = UIColor.lightGray
            break
        case let .update(date, text, values, imageId):
            
            imageSelected = imageId
            loadImage(image: imageSelected!)
            
            if (imageView.image != nil) {
                cameraButton1.isEnabled = false
                cameraButton1.isHidden = true
                cameraButton2.isEnabled = false
                cameraButton2.isHidden = true
                libraryButton1.isEnabled = false
                libraryButton1.isHidden = true
                libraryButton2.isEnabled = false
                libraryButton2.isHidden = true
                deleteButton.isEnabled = true
                deleteButton.isHidden = false
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            navigationItem.title = dateFormatter.string(from: date)
            dateTextField.text = dateFormatter.string(from: date)
            dateSelected = date
            textView.text = text
            hsSlider.value = values[0]
            psSlider.value = values[1]
            cuSlider.value = values[2]
        }
        
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
        let date = dateSelected!
        let text = textView.text ?? ""
        let values = [hsSlider.value, psSlider.value, cuSlider.value]
        
        // No image selected, adding new log
        if imageView.image == nil {
            deleteImage(image: imageSelected!)
        } else {
            saveImage(image: imageSelected!)
        }

        if callback != nil{
            callback!(date, text, values, imageSelected!)
        }
    }
    
    // MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            print("setting imageView image")
            cameraButton1.isEnabled = false
            cameraButton1.isHidden = true
            cameraButton2.isEnabled = false
            cameraButton2.isHidden = true
            libraryButton1.isEnabled = false
            libraryButton1.isHidden = true
            libraryButton2.isEnabled = false
            libraryButton2.isHidden = true
            deleteButton.isEnabled = true
            deleteButton.isHidden = false
        } else {
            //Error message
            print("imagePicker error")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // TextView Placeholder text implementation
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "How are you feeling?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Date Picker Implementation
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateSelected = sender.date
        dateTextField.text = formatter.string(from: sender.date)
    }
    @IBAction func setCurrentDate(_ sender: UIButton) {
        let todaysDate = Date()
        dateSelected = todaysDate
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        dateTextField.text = df.string(from: todaysDate)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateTextField.resignFirstResponder()
        return true
    }
    
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    
    func saveImage(image: String) {
        let fm = FileManager.default
        let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImages")
        if !fm.fileExists(atPath: dirPath) {
            try! fm.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("Directory already created.")
        }
        
        let filePath = dirPath.appending("/" + image + ".png")
        let imageData = UIImagePNGRepresentation(imageView.image!)
        if (fm.fileExists(atPath: filePath)) {
            try! fm.removeItem(atPath: filePath)
        }
        fm.createFile(atPath: filePath, contents: imageData, attributes: nil)
    }
    
    func deleteImage(image: String) {
        let fm = FileManager.default
        let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImages")
        let imagePath = dirPath.appending("/" + image + ".png")
        if fm.fileExists(atPath: imagePath) {
            try! fm.removeItem(atPath: imagePath)
        }
    }
    
    func loadImage(image: String) {
        let fm = FileManager.default
        let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImages")
        let imagePath = dirPath.appending("/" + image + ".png")
        if fm.fileExists(atPath: imagePath) {
            imageView.image = UIImage(contentsOfFile: imagePath)
        } else {
            print("no image.")
        }
    }
}


enum DetailType{
    case new
    case update(Date, String, [Float], String)
}
