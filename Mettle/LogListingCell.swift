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
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: (log.date as Date?)!)
        
        // If image assocated with log, load image
        if (!loadImage(image: log.imageId!)) {
            cellCustomView.updateValues(top: log.hsValue, mid: log.psValue, bot: log.cuValue)
            cellCustomView.isHidden = false
            cellImageView.isHidden = true
            cellCustomView.layer.cornerRadius = 5
        } else {
            cellCustomView.isHidden = true
            cellImageView.isHidden = false
            cellImageView.layer.cornerRadius = 5
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
