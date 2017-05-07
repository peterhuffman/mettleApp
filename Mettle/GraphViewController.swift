//
//  GraphViewController.swift
//  Mettle
//
//  Created by Gordon Nickerson on 5/7/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var logs: [LogMock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartWithData()
        
        lineChartView.delegate = self
        
        lineChartView.setScaleEnabled(false)
        initLogs(10)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLogs(_ days: Int) {
        for i in days...1 {
            var happySad:Int = Int(arc4random_uniform(7));
            happySad -= 3
            var prideShame:Int = Int(arc4random_uniform(7));
            prideShame -= 3
            var calmUpset:Int = Int(arc4random_uniform(7));
            calmUpset -= 3
            
            let date = Date().addingTimeInterval(-Double(i)*24*60*60)
            
            logs.append(LogMock.init(happySad: Float(happySad), prideShame: Float(prideShame), calmUpset: Float(calmUpset), date: date))
        }
    }
    
    func updateChartWithData() {
        var dataEntries1: [ChartDataEntry] = []
        
        
        dataEntries1.append(ChartDataEntry(x: 0, y: 3))
        dataEntries1.append(ChartDataEntry(x: 1, y: 2))
        dataEntries1.append(ChartDataEntry(x: 2, y: 3))
        dataEntries1.append(ChartDataEntry(x: 3, y: 3))
        dataEntries1.append(ChartDataEntry(x: 4, y: 2))
        dataEntries1.append(ChartDataEntry(x: 5, y: 3))
        dataEntries1.append(ChartDataEntry(x: 6, y: 3))
        dataEntries1.append(ChartDataEntry(x: 7, y: 2))
        dataEntries1.append(ChartDataEntry(x: 8, y: 3))
        dataEntries1.append(ChartDataEntry(x: 9, y: 3))
        
        var dataEntries2: [ChartDataEntry] = []
        
        
        dataEntries2.append(ChartDataEntry(x: 0, y: 0))
        dataEntries2.append(ChartDataEntry(x: 1, y: -3))
        dataEntries2.append(ChartDataEntry(x: 2, y: -1))
        dataEntries2.append(ChartDataEntry(x: 3, y: 0))
        dataEntries2.append(ChartDataEntry(x: 4, y: -3))
        dataEntries2.append(ChartDataEntry(x: 5, y: -1))
        dataEntries2.append(ChartDataEntry(x: 6, y: 0))
        dataEntries2.append(ChartDataEntry(x: 7, y: -3))
        dataEntries2.append(ChartDataEntry(x: 8, y: -1))
        dataEntries2.append(ChartDataEntry(x: 9, y: 0))
        
        var dataEntries3: [ChartDataEntry] = []
        
        
        dataEntries3.append(ChartDataEntry(x: 0, y: 1))
        dataEntries3.append(ChartDataEntry(x: 1, y: -2))
        dataEntries3.append(ChartDataEntry(x: 2, y: 2))
        dataEntries3.append(ChartDataEntry(x: 3, y: 1))
        dataEntries3.append(ChartDataEntry(x: 4, y: -2))
        dataEntries3.append(ChartDataEntry(x: 5, y: 2))
        dataEntries3.append(ChartDataEntry(x: 6, y: 1))
        dataEntries3.append(ChartDataEntry(x: 7, y: -2))
        dataEntries3.append(ChartDataEntry(x: 8, y: 2))
        dataEntries3.append(ChartDataEntry(x: 9, y: -2))
        
        let lineDataSet = LineChartDataSet(values: dataEntries1, label: "Happiness")
        
        let lineDataSet2 = LineChartDataSet(values: dataEntries2, label: "Pride")
        
        let lineDataSet3 = LineChartDataSet(values: dataEntries3, label: "Relaxedness")
        
        lineDataSet.setColor(NSUIColor.blue)
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.mode = LineChartDataSet.Mode.cubicBezier
        
        lineDataSet2.setColor(NSUIColor.green)
        lineDataSet2.drawCirclesEnabled = false
        lineDataSet2.mode = LineChartDataSet.Mode.cubicBezier
        
        lineDataSet3.setColor(NSUIColor.red)
        lineDataSet3.drawCirclesEnabled = false
        lineDataSet3.mode = LineChartDataSet.Mode.cubicBezier

        let lineData = LineChartData(dataSets: [lineDataSet, lineDataSet2, lineDataSet3])
        
        lineChartView.data = lineData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {

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
