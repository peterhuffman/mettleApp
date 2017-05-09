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
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var feelingSegment: UISegmentedControl!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            initLogs(10)
            
        case 1:
            initLogs(30)
            
        case 2:
            initLogs(60)
            
        case 3:
            initLogs(120)

        default:
            break
        }
        
    
        updateChartWithData()
    }
    var logs: [LogMock] = []
    var buckets: [Bucket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        axisFormatDelegate = self
        
        //lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        lineChartView.setScaleEnabled(false)
        lineChartView.chartDescription?.enabled = false
        
        lineChartView.animate(yAxisDuration: 3.0)
        
        let xaxis = lineChartView.xAxis
        xaxis.labelPosition = XAxis.LabelPosition.bottom
        xaxis.valueFormatter = axisFormatDelegate
        
                
        initLogs(10)
        updateChartWithData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLogs(_ days: Int) {
        logs = []
        
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
        
        fillBuckets()
    }
    
    func fillBuckets() {
        buckets = []
        let bucketSize = logs.count/10
        
        for i in 0...9 {
            var bucketLogs: [LogMock] = []
            let date = logs[i*bucketSize].date
            for j in 0..<bucketSize {
                bucketLogs.append(logs[i*bucketSize + j])
            }
            
            buckets.append(Bucket.init(logs: bucketLogs, label: date))
        }
    }
    
    func updateChartWithData() {
        var happyEntries: [ChartDataEntry] = []
        var prideEntries: [ChartDataEntry] = []
        var calmEntries: [ChartDataEntry] = []
        
        for i in 0..<buckets.count {
            happyEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averageHappy))
            prideEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averagePride))
            calmEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averageCalm))
        }
        
    
        let happyDataSet = LineChartDataSet(values: happyEntries, label: "Happiness")
        
        let prideDataSet = LineChartDataSet(values: prideEntries, label: "Pride")
        
        let calmDataSet = LineChartDataSet(values: calmEntries, label: "Calmness")
        
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
        
        var lineData: LineChartData
        switch feelingSegment.selectedSegmentIndex {
        case 0: lineData = LineChartData(dataSet: happyDataSet)
        case 1: lineData = LineChartData(dataSet: prideDataSet)
        case 2: lineData = LineChartData(dataSet: calmDataSet)
        case 3: lineData = LineChartData(dataSets: [happyDataSet, prideDataSet, calmDataSet])
        default:
            lineData = LineChartData(dataSets: [happyDataSet, prideDataSet, calmDataSet])
        }
        lineData.setDrawValues(false)
        
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

// MARK: axisFormatDelegate
extension GraphViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        let i: Int = Int(value)
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: buckets[i].label)
    }
}

class Bucket{
    var logs: [LogMock] = []
    var label: Date
    var averageHappy: Double
    var averagePride: Double
    var averageCalm: Double
    
    init(logs: [LogMock], label: Date) {
        self.logs = logs
        self.label = label
        
        var happyAvg = 0.0
        var prideAvg = 0.0
        var calmAvg = 0.0
        for log in logs {
            happyAvg += Double(log.happySad)
            prideAvg += Double(log.prideShame)
            calmAvg += Double(log.calmUpset)
        }
        
        self.averageHappy = happyAvg/Double(logs.count)
        self.averagePride = prideAvg/Double(logs.count)
        self.averageCalm = calmAvg/Double(logs.count)
    }
}

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
