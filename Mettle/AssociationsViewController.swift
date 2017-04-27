//
//  AnalysisViewController.swift
//  Mettle
//
//  Created by Peter Huffman on 4/27/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class AssociationsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func hsButtonPressed(_ sender: UIButton) {
        imageView.image = UIImage(named: "hsChart")
    }
    @IBAction func pgButtonPressed(_ sender: UIButton) {
        imageView.image = UIImage(named: "pgChart")
    }
    @IBAction func rsButtonPressed(_ sender: UIButton) {
        imageView.image = UIImage(named: "rsChart")
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
