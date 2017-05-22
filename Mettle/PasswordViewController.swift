//
//  PasswordViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 5/21/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import CoreData

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    let limitLength = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 5
        textField.text = UserDefaults.standard.value(forKey: "password") as? String
        
        textField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePassword(_ sender: UIButton) {
        UserDefaults.standard.setValue(textField.text, forKey: "password")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
