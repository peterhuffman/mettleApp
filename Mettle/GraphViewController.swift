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
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var logs: [LogMock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        axisFormatDelegate = self
        
        //lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        lineChartView.setScaleEnabled(false)
        
        initLogs(10)
        updateChartWithData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLogs(_ days: Int) {
        for i in (1...days).reversed() {
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
        var happyEntries: [ChartDataEntry] = []
        var prideEntries: [ChartDataEntry] = []
        var calmEntries: [ChartDataEntry] = []
        
        for i in 0..<logs.count {
            happyEntries.append(ChartDataEntry(x: Double(i), y: Double(logs[i].happySad)))
            prideEntries.append(ChartDataEntry(x: Double(i), y: Double(logs[i].prideShame)))
            calmEntries.append(ChartDataEntry(x: Double(i), y: Double(logs[i].calmUpset)))
        }
        
    
        let happyDataSet = LineChartDataSet(values: happyEntries, label: "Happy/Sad")
        
        let prideDataSet = LineChartDataSet(values: prideEntries, label: "Pride/Shame")
        
        let calmDataSet = LineChartDataSet(values: calmEntries, label: "Calm/Upset")
        
        happyDataSet.setColor(NSUIColor.blue)
        happyDataSet.lineWidth = 2.5
        happyDataSet.drawCirclesEnabled = false
        happyDataSet.mode = LineChartDataSet.Mode.cubicBezier
        happyDataSet.cubicIntensity = 0.15
        
        prideDataSet.setColor(NSUIColor.green)
        prideDataSet.lineWidth = 2.5
        prideDataSet.drawCirclesEnabled = false
        prideDataSet.mode = LineChartDataSet.Mode.cubicBezier
        prideDataSet.cubicIntensity = 0.15
        
        calmDataSet.setColor(NSUIColor.red)
        calmDataSet.lineWidth = 2.5
        calmDataSet.drawCirclesEnabled = false
        calmDataSet.mode = LineChartDataSet.Mode.cubicBezier
        calmDataSet.cubicIntensity = 0.15

        let lineData = LineChartData(dataSets: [happyDataSet, prideDataSet, calmDataSet])
        lineData.setDrawValues(false)
        
        lineChartView.data = lineData
        lineChartView.chartDescription?.enabled = false
        
        let xaxis = lineChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
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

// MARK: axisFormatDelegate
extension GraphViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        let i: Int = Int(value)
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: logs[i].date)
    }
}
