//
//  Log.swift
//  Mettle
//
//  Created by Gordon Nickerson on 5/7/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import Foundation

class LogMock{
    var happySad: Float
    var prideShame: Float
    var calmUpset: Float
    var date: Date
    
    init(happySad: Float, prideShame: Float, calmUpset: Float, date: Date) {
        self.happySad = happySad
        self.prideShame = prideShame
        self.calmUpset = calmUpset
        self.date = date
    }
}
