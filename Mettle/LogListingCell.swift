 //
//  LogListingCell.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class LogListingCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellCustomView: customCellView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(log: Log){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: (log.date as Date?)!)
//        print("configuring cell")
        
        // If image assocated with log, load image
        if (!loadImage(image: log.imageId!)) {
//            print("draw custom view")
            cellCustomView.updateValues(top: log.hsValue, mid: log.psValue, bot: log.cuValue)
//            cellCustomView.draw(CGRect(x: 0, y: 0, width: 1, height: 1))
            cellCustomView.isHidden = false
            cellImageView.isHidden = true
        } else {
            cellCustomView.isHidden = true
            cellImageView.isHidden = false
        }
        
    }
    
    // Loads log thumbnail from user Documents
    func loadImage(image: String) -> Bool {
        let fm = FileManager.default
        let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImages")
        let imagePath = dirPath.appending("/" + image + ".png")
        if fm.fileExists(atPath: imagePath) {
            cellImageView.image = UIImage(contentsOfFile: imagePath)
            return true
        } else {
            print("no image.")
            return false
        }
    }

}
