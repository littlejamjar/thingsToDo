//
//  Task+CoreDataProperties.swift
//  ThingsToDo
//
//  Created by james wikaira on 30/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var text: String?
    @NSManaged var isComplete: NSNumber?
    @NSManaged var isHot: NSNumber?
    @NSManaged var dueDateTime: NSDate?
    @NSManaged var subFolder: SubFolder?

}
