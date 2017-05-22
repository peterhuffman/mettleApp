//
//  EraseViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 5/21/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import CoreData

class EraseViewController: UIViewController {

    @IBOutlet weak var eraseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eraseButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearAllData(_ sender: UIButton) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
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
