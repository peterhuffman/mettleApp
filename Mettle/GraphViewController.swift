//
//  GraphViewController.swift
//  Mettle
//
//  Created by Gordon Nickerson on 5/7/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import CoreData
import Charts

class GraphViewController: UIViewController, ChartViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var feelingSegment: UISegmentedControl!
    
    var logList: LogListingController!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var happyColor:NSUIColor = UIColor.init(rgb: 0xCC0F10)
    var proudColor:NSUIColor = UIColor.init(rgb: 0xEDF01C)
    var calmColor:NSUIColor = UIColor.init(rgb: 0x2A75B2)
    
    var logs: [Log] = []
    var buckets: [Bucket] = []
    var startDates: [Date] = []
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        fetchLogs()
        fillBuckets()
        updateChartWithData()
        lineChartView.animate(yAxisDuration: 0.75)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        
        lineChartView.delegate = self
        axisFormatDelegate = self
        lineChartView.layer.cornerRadius = 10
        
        lineChartView.legend.font = NSUIFont.systemFont(ofSize: CGFloat(17.0))
        lineChartView.legend.formSize = CGFloat(15.0)
        
        
        lineChartView.setScaleEnabled(false)
        lineChartView.chartDescription?.enabled = false
        
        lineChartView.animate(yAxisDuration: 2.0)
        
        let rightAxis = lineChartView.rightAxis
        rightAxis.axisMinimum = -3;
        rightAxis.axisMaximum = 3;
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisMinimum = -3;
        leftAxis.axisMaximum = 3;
        
        let xaxis = lineChartView.xAxis
        xaxis.labelPosition = XAxis.LabelPosition.bottom
        xaxis.valueFormatter = axisFormatDelegate
        
        fetchLogs()
        fillBuckets()
        updateChartWithData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fillBuckets() {
        var decrement : Double
        switch segment.selectedSegmentIndex {
        case 0: decrement = 1.0
        case 1: decrement = 3.0
        case 2: decrement = 6.0
        case 3: decrement = 12.0
        default: decrement = 1.0
        }
        
        startDates = []
        
        for i in (1...10).reversed() {
            startDates.append(Date().addingTimeInterval(-Double(i)*decrement*24*60*60))
        }
        
        startDates.append(Date())
        
        var buckets : [Bucket] = []
        
        for i in 0...9 {
            buckets.append(Bucket.init(start: startDates[i], end: startDates[i+1]))
        }
        
        for log in logs {
            for bucket in buckets {
                let fallsBetween = (bucket.label...bucket.end).contains(log.date! as Date)
                if (fallsBetween) {
                    bucket.add(log)
                }
            }
        }
        
        for bucket in buckets {
            bucket.calcAvg()
        }
        
        self.buckets = buckets
    }
    
    func fetchLogs() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        var startDate : NSDate
        switch segment.selectedSegmentIndex {
        case 0:
            startDate = Date().addingTimeInterval(-10.0*24*60*60) as NSDate
        case 1:
            startDate = Date().addingTimeInterval(-30.0*24*60*60) as NSDate
        case 2:
            startDate = Date().addingTimeInterval(-60.0*24*60*60) as NSDate
        case 3:
            startDate = Date().addingTimeInterval(-120.0*24*60*60) as NSDate
        default:
            startDate = Date().addingTimeInterval(-10.0*24*60*60) as NSDate
        }
        let endDate = Date() as NSDate
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)

        
        do {
            let results = try context.fetch(fetchRequest)
            let Logs = results as! [Log]
            
            logs = Logs
        } catch let error as NSError {
            print(error)
        }
    }
    
    func updateChartWithData() {
        var happyEntries: [ChartDataEntry] = []
        var prideEntries: [ChartDataEntry] = []
        var calmEntries: [ChartDataEntry] = []
        
        for i in 0..<buckets.count {
            if (!buckets[i].isEmpty()) {
                happyEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averageHappy))
                prideEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averagePride))
                calmEntries.append(ChartDataEntry(x: Double(i), y: buckets[i].averageCalm))
            }
        }
    
        let happyDataSet = LineChartDataSet(values: happyEntries, label: "Happiness")
        
        let prideDataSet = LineChartDataSet(values: prideEntries, label: "Pride")
        
        let calmDataSet = LineChartDataSet(values: calmEntries, label: "Calmness")
        
        happyDataSet.setColor(happyColor)
        happyDataSet.setCircleColor(happyColor)
        happyDataSet.circleRadius = 5.0
        happyDataSet.lineWidth = 2.5
        happyDataSet.mode = LineChartDataSet.Mode.cubicBezier
        happyDataSet.cubicIntensity = 0.125
        
        prideDataSet.setColor(proudColor)
        prideDataSet.setCircleColor(proudColor)
        prideDataSet.circleRadius = 5.0
        prideDataSet.lineWidth = 2.5
        prideDataSet.mode = LineChartDataSet.Mode.cubicBezier
        prideDataSet.cubicIntensity = 0.125
        
        calmDataSet.setColor(calmColor)
        calmDataSet.setCircleColor(calmColor)
        calmDataSet.circleRadius = 5.0
        calmDataSet.lineWidth = 2.5
        calmDataSet.mode = LineChartDataSet.Mode.cubicBezier
        calmDataSet.cubicIntensity = 0.125
        
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
        let bucket = buckets[Int(entry.x)]
        if (logList != nil) {
            logList.fetchWithinDates(start: bucket.label, end: bucket.end)
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "graphListSegue") {
            logList = segue.destination as! LogListingController
        }
    }

}

// MARK: axisFormatDelegate
extension GraphViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        let i: Int = Int(value)
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: startDates[i])
    }
}

class Bucket{
    var logs: [Log] = []
    var label: Date
    var end: Date
    var averageHappy: Double
    var averagePride: Double
    var averageCalm: Double
    
    init(start: Date, end: Date) {
        self.label = start
        self.end = end
        
        self.averageHappy = 0.0
        self.averagePride = 0.0
        self.averageCalm = 0.0
    }
    
    func add(_ log: Log) {
        logs.append(log)
    }
    
    func calcAvg() {
        var happyAvg = 0.0
        var prideAvg = 0.0
        var calmAvg = 0.0
        for log in logs {
            happyAvg += Double(log.hsValue)
            prideAvg += Double(log.psValue)
            calmAvg += Double(log.cuValue)
        }
        
        self.averageHappy = happyAvg/Double(logs.count)
        self.averagePride = prideAvg/Double(logs.count)
        self.averageCalm = calmAvg/Double(logs.count)
    }
    
    func isEmpty() -> Bool {
        return !(logs.count > 0)
    }
}
