//
//  LogCollection.swift
//  Mettle
//
//  Created by Peter Huffman on 4/25/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import Foundation
import CoreData

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
    
    /* Add a new book to the collection */
    func add(date: Date, text: String, values: [Float]){
        var log:Log!
        managedObjectContext.performAndWait {
            log = Log(context: self.managedObjectContext)
            log.date = date as NSDate
            log.text = text
            log.hsValue = values[0]
            log.pgValue = values[1]
            log.rsValue = values[2]
            self.saveChanges()
        }
    }
    
    /* Update the fields on a book
     
     We make this a seperate function rather than setting the values directly so that we can use findAuthor and save changes.
     */
    func update(oldLog: Log, date: Date, text: String, values: [Float]){
        oldLog.date = date as NSDate
        oldLog.text = text
        oldLog.hsValue = values[0]
        oldLog.pgValue = values[1]
        oldLog.rsValue = values[2]
        self.saveChanges()
    }
    
    /*
     Remove a book from the collection
     */
    func delete(_ log: Log){
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
