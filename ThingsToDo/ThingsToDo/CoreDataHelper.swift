//
//  CoreDataHelper.swift
//  iCandCDTutorial
//
//  Created by james wikaira on 13/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    class func insertManagedObject(className: NSString, managedObjectContext: NSManagedObjectContext) -> AnyObject{
        let managedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext) as NSManagedObject
        
        return managedObject
    }
    
    class func fetchEntities (className: NSString, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?) -> NSArray{
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        //let contents: NSString?
        var items = [AnyObject]()
        do {
            items = try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch _ {
            print("Error trying to execute fetch request..")
        }
        
        return items
    }
}
