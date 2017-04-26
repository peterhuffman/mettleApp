//
//  LogDetailViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    var type: DetailType = .new
    var callback: ((Date, String)->Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .update(date, text):
            datePicker.date = date
            entryField.text = text
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
        let date = datePicker.date 
        let text = entryField.text ?? ""
        
        if callback != nil{
            callback!(date, text)
        }
    }
    
    
}


enum DetailType{
    case new
    case update(Date, String)
}
