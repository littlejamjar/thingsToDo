//
//  Folder+CoreDataProperties.swift
//  ThingsToDo
//
//  Created by james wikaira on 16/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Folder {

    @NSManaged var title: String?
    @NSManaged var creationDate: NSDate?
    @NSManaged var isComplete: NSNumber?
    @NSManaged var subFolders: NSSet?

}
