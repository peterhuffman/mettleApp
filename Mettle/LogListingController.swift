//
//  LogListingController.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import CoreData

class LogListingController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var dateSelected: Date!
    
    
    private let logs = LogCollection(){
        print("Core Data connected")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        
        // Add the edit button on the left side programmatically
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        initializeFetchResultsController()
    }
    
    
    /*
     Initialize the fetched results controller
     
     We configure this to fetch all of the books and break them into sections based on author name.
     */
    func initializeFetchResultsController(){
        // get all books
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Log")
        

        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]
        
        // Create the controller using our moc
        let moc = logs.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "date", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }
        
    }
    
    func fetchWithinDates(start: Date, end:Date){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Log")
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", start as CVarArg, end as CVarArg)
        print(start)
        print(end)
        let moc = logs.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "date", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            //let results = try context.fetch(request)
            //let  logs = results as! [Log]
            //print(logs.count)
            try fetchedResultsController.performFetch()
            print(fetchedResultsController.sections!.count)
            tableView.reloadData()

        }catch{
            fatalError("Failed to fetch data")
        }
    }
    
    
    
    
    // MARK: - Table view data source functions
    
    /* Report the number of sections (managed by fetched results controller) */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    /* Report the number of rows in a particular section (managed by fetched results controller) */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController!.sections else{
            fatalError("No sections found")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
//        return 1
    }
    
    /* Get a table cell loaded with the right data for the entry at indexPath (section/row)*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get one of our custom cells, building or reusing as needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as? LogListingCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        guard let log = self.fetchedResultsController.object(at: indexPath) as? Log else{
            fatalError("Cannot find book")
        }
        
        cell.configureCell(log: log)
        
        return cell
    }
    
//    /* Get the title to be displayed between sections */
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let sections = fetchedResultsController.sections else{
//            fatalError("No sections in fetchedResultsController")
//        }
//        let sectionInfo = sections[section]
//        var newDate : Date = Date()
//        
//        for object in sectionInfo.objects! {
//            switch object {
//            case let newLog as Log:
//                newDate = newLog.date! as Date
//            default:
//                print("not a log.. :/")
//            }
//        }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        
//        return dateFormatter.string(from: newDate)
//    }
    
    /* Provides the edit functionality (deleteing rows) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let log = self.fetchedResultsController?.object(at: indexPath) as? Log else{
                fatalError("Cannot find log")
            }
            
            logs.delete(log)
        }
    }
    
    
    // MARK: Connect tableview to fetched results controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // MARK: - Navigation
    
    // prepare to go to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "AddLog":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? LogDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (date, text, values, imageId) in
                self.logs.add(date: date, text: text, values: values, imageId: imageId)
            }
        case "EditLog":
            
            guard let destination = segue.destination as? LogDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? LogListingCell else{
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let log = fetchedResultsController?.object(at: indexPath) as? Log else{
                fatalError("fetched object was not a Book")
            }
            
            
            destination.type = .update(log.date! as Date, log.text!, [log.hsValue, log.psValue, log.cuValue], log.imageId!)
            destination.callback = { (date, text, values, imageId) in
                self.logs.update(oldLog: log, date: date, text: text, values: values, imageId: imageId)
            }
            
        case "GraphLog":
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let destination = navController.topViewController as? LogDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? LogListingCell else{
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let log = fetchedResultsController?.object(at: indexPath) as? Log else{
                fatalError("fetched object was not a Book")
            }
            
            destination.type = .update(log.date! as Date, log.text!, [log.hsValue, log.psValue, log.cuValue], log.imageId!)
            destination.callback = { (date, text, values, imageId) in
                self.logs.update(oldLog: log, date: date, text: text, values: values, imageId: imageId)
            }
            
            
        default:
            fatalError("Unexpeced segue identifier: \(String(describing: segue.identifier))")
        }
        
    }
    
    /* This is here so that we have something to return to. It doesn't actually provide much functionality since the tableView is already tied to the fetched results controller. */
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    
}
