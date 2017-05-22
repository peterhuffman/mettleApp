//
//  LoginViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 5/21/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import SmileLock

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    //MARK: Property
    var passwordUIValidation: MyPasswordUIValidation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create PasswordUIValidation subclass
        passwordUIValidation = MyPasswordUIValidation(in: passwordStackView)
        
        passwordUIValidation.success = { [weak self] _ in

            self?.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        
        passwordUIValidation.failure = { _ in
        }
        
        //visual effect password UI
        passwordUIValidation.view.rearrangeForVisualEffectView(in: self)
        
        passwordUIValidation.view.deleteButtonLocalizedTitle = "Clear"
    }
}
