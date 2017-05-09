//
//  customCellView.swift
//  Mettle
//
//  Created by Peter Huffman on 5/7/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class customCellView: UIView {

    private var viewCenter: CGPoint {
        get {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    private var barHeightConst: CGFloat {
        get {
            return CGFloat(bounds.height / 10)
        }
    }
    
    private var barWidthConst: CGFloat {
        get {
            return CGFloat(bounds.width / 6)
        }
    }
    
    var topValue: Float = 0.0
    var midValue: Float = 0.0
    var botValue: Float = 0.0

    override func draw(_ rect: CGRect) {
//        print("drawing cell")
        
        // Draw top bar
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: bounds.midX, y: barHeightConst * 1))
        topPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(topValue)), y: barHeightConst * 1))
        topPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(topValue)), y: barHeightConst * 3))
        topPath.addLine(to: CGPoint(x: bounds.midX, y: barHeightConst * 3))
        topPath.lineWidth = 1
        UIColor.clear.set()
        topPath.stroke()
        UIColor.red.set()
        topPath.fill()
        
        
        
        // Draw middle bar
        let midPath = UIBezierPath()
        midPath.move(to: CGPoint(x: bounds.midX, y: barHeightConst * 4))
        midPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(midValue)), y: barHeightConst * 4))
        midPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(midValue)), y: barHeightConst * 6))
        midPath.addLine(to: CGPoint(x: bounds.midX, y: barHeightConst * 6))
        midPath.lineWidth = 1
        UIColor.clear.set()
        midPath.stroke()
        UIColor.yellow.set()
        midPath.fill()
        
        // Draw bottom bar
        let botPath = UIBezierPath()
        botPath.move(to: CGPoint(x: bounds.midX, y: barHeightConst * 7))
        botPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(botValue)), y: barHeightConst * 7))
        botPath.addLine(to: CGPoint(x: bounds.midX + (barWidthConst * CGFloat(botValue)), y: barHeightConst * 9))
        botPath.addLine(to: CGPoint(x: bounds.midX, y: barHeightConst * 9))
        botPath.lineWidth = 1
        UIColor.clear.set()
        botPath.stroke()
        UIColor.blue.set()
        botPath.fill()
        
        // Draw line down the middle
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        linePath.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        linePath.lineWidth = 1
        UIColor.gray.set()
        linePath.stroke()
    }
    
    func updateValues(top: Float, mid: Float, bot: Float) {
        topValue = top
        midValue = mid
        botValue = bot
    }
}
