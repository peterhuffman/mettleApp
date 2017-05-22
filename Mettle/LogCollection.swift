//
//  LogCollection.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LogCollection{
    
    var managedObjectContext: NSManagedObjectContext // our in-memory data store and portal to the database
    var persistentContainer: NSPersistentContainer // our database connection
    
    
    /* Initializes our collection by connecting to the database.
     
     The closure is called when the connection has been established.
     */
    init(completionClosure: @escaping ()->()){
        persistentContainer = NSPersistentContainer(name:"Mettle")
        managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores(){ (description, err) in
            if let err = err{
                // should try harder to mkae the connection and not just dump the user
                fatalError("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
    }
    
    /* Add a new log to the collection */
    func add(date: Date, text: String, values: [Float], imageId: String){
        var log:Log!
        managedObjectContext.performAndWait {
            log = Log(context: self.managedObjectContext)
            log.date = date as NSDate
            log.text = text
            log.hsValue = values[0]
            log.psValue = values[1]
            log.cuValue = values[2]
            log.imageId = imageId
            
            // Format date for section header
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            log.sectionDate = df.date(from: df.string(from: date))! as NSDate
            self.saveChanges()
        }
    }
    
    /* Update the fields on a log
     
     We make this a seperate function rather than setting the values directly so that we can use findAuthor and save changes.
     */
    func update(oldLog: Log, date: Date, text: String, values: [Float], imageId: String){
        oldLog.date = date as NSDate
        oldLog.text = text
        oldLog.hsValue = values[0]
        oldLog.psValue = values[1]
        oldLog.cuValue = values[2]
        oldLog.imageId = imageId
        self.saveChanges()
    }
    
    /*
     Remove a log from the collection
     */
    func delete(_ log: Log){
        
        // Remove associated photo before deleting log
        let fm = FileManager.default
        let dirPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImages")
        let imagePath = dirPath.appending("/" + log.imageId! + ".png")
        if fm.fileExists(atPath: imagePath) {
            try! fm.removeItem(atPath: imagePath)
        }
        
        managedObjectContext.delete(log)
        self.saveChanges()
    }
    
    
    /*
     Save any changes stored in our moc back to the database.
     */
    func saveChanges () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
