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
    @IBOutlet weak var entryField: UILabel!

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
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: (log.date as Date?)!)
        entryField.text = log.text
    }

}
