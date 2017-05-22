//
//  HomeViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 5/21/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // Loads the passcode lock screen if the user requires a passcode, performs segue to tab bar controller
    @IBAction func buttonpressed(_ sender: Any) {
        if let pc = UserDefaults.standard.value(forKey: "requirePasscode") as? Bool {
            if pc {
                present()
            } else {
                self.performSegue(withIdentifier: "TabBarSegue", sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: "TabBarSegue", sender: nil)
        }
    }
    
    func present() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC?.modalPresentationStyle = .popover
        present(loginVC!, animated: true, completion: nil)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "TabBarController" {
//            guard segue.destination is UITabBarController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            
//        }
//    }


}
