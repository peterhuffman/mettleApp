//
//  CalendarViewController.swift
//  Mettle
//
//  Created by Matthew Linkous on 4/26/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedMonthColor = UIColor.gray
    let todayDateColor = UIColor.blue
    var logList: LogListingController!
    var logDates = [Date: Bool]()
    
    
    private let logs = LogCollection(){
        print("Core Data connected")
        
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        
        setupCalendar()
    }
    
    
    /* Calendar Functions */
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else { return }
        if cellState.isSelected == true {
            validCell.DateLabel.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth {
                validCell.DateLabel.textColor = monthColor
            }else{
                validCell.DateLabel.textColor = outsideMonthColor
            }
            if cellState.date.startOfDay == Date().startOfDay {
                validCell.DateLabel.textColor = todayDateColor
            }
        }

    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else { return }
        if hasLog(date: cellState.date) {
            validCell.hasLogView.isHidden = false
        }else{
            validCell.hasLogView.isHidden = true
        }
        if cellState.isSelected == true {
            let date = cellState.date
            formatter.dateFormat = "MM / dd / yyyy"
            dateLabel.text = formatter.string(from: date)
            validCell.selectedView.isHidden = false
            logList.fetchWithinDates(start: date.startOfDay, end: date.endOfDay!)
        }else{
            validCell.selectedView.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCalendar(){
        fetchLogs()
        calendarView.scrollToDate(Date())
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func hasLog(date: Date) -> Bool {
        return (logDates[date.startOfDay] == true)
    }
    
    func fetchLogs() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        do {
            let results = try context.fetch(fetchRequest)
            let Logs = results as! [Log]
            for log in Logs {
                let date = log.date! as Date
                logDates[date.startOfDay] = true
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from:date)
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from:date)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "dateListSegue") {
            logList = segue.destination as! LogListingController
        }
    }

}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.DateLabel.text = cellState.text
        handleCellSelected(cell: cell, cellState: cellState)
         handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}
