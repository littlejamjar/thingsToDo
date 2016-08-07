//
//  TasksTVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 30/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit
import CoreData

class TasksTVC: UITableViewController {
    
    // Property declarations
    var actionToEnable: UIAlertAction?
    var moc: NSManagedObjectContext!
    var objArray = [NSManagedObject]()
    var task: Task?
    var subFolder: SubFolder?
    
    var selectedObj: NSObject?
    
    //let searchController = UISearchController(searchResultsController: nil) //FIXME: argument of nil means use current view i think???
    
    var filteredSubFolders = [SubFolder]()
    
    var num = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Managed Object Context
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        //fetchRequest.predicate = NSPredicate(format: "title = %@", argumentArray: ["jim"])
        
        //FIXME: what is this doing?
        if subFolder?.title != nil {
            //print("it's not nil!!!")
            self.navigationItem.title = subFolder!.title
            
        } else {
            //print("subfolder is NIL!!")
        }
        
        let pred = NSPredicate(format: "subFolder == %@", subFolder!)
        
        fetchRequest.predicate = pred
        
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            objArray = results as! [NSManagedObject]
            //print("subFolders.count = \(objArray.count)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } catch {
            print("some other error")
        }
    
        
        let addFolderButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TasksTVC.addTask))
        //let searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(SubFoldersTVC.search))
        let addDueDateTimeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: #selector(TasksTVC.createSubTask)) //TODO: Get a better menu picture
        
        let rightBarButtonItemArray = [ addFolderButtonItem, addDueDateTimeButtonItem ]
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItemArray
    }
    
    func createSubTask(taskParent: Task){
        
        print("Creating sub task")
        
        let text = "Sub Task :: \(taskParent.text)"
        
        
        guard let entity = NSEntityDescription.entityForName("SubTask", inManagedObjectContext: moc) else {
            print("Error: Could not create entity")
            return
        }
        
        let newSubTask = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc) as! SubTask
        
        
        newSubTask.text = text
        newSubTask.creationDate = NSDate()
        newSubTask.isComplete = false
        newSubTask.isHot = false
        newSubTask.dueDateTime = nil
        newSubTask.task = taskParent
        
        
        do{
            try moc.save()
            //objArray.append(newSubTask)    //FIXME: What about this???
        } catch {
            print("Error: Could not save new folder from Managed Object Context")
        }
        
    }

    

    func addDueDateTime(){
        print("TODO:IMPLEMENT CODE")
    }
    
    func addTask() {
        
        // Creat Alert Controller
        let alertController = UIAlertController(title: "Add Task", message: "Enter Task title", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        // Create the Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled
            print("User cancelled the new Task")
        }
        
        // Create the Add button
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            //print("Should have made the new Task")
            
            guard let title = alertController.textFields![0].text else {
                print("No title")
                return
            }
            
            self.createTask(title)
        }
        
        // Add buttons to the Alert Controller
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Set actionToEnable to the addAction Alert Action.
        self.actionToEnable = addAction
        
        // Set the Action Button to false initially because nothing will be within the Text Field
        addAction.enabled = false
        
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func createTask(text: String){
        
        guard let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: moc) else {
            print("Error: Could not create entity")
            return
        }
        
        let newTask = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc) as! Task
        
        
        newTask.text = text
        newTask.creationDate = NSDate()
        newTask.isComplete = false
        newTask.isHot = false
        newTask.dueDateTime = nil
        newTask.subFolder = subFolder
        newTask.subTasks = nil
        
        do{
            try moc.save()
            objArray.append(newTask)
        } catch {
            print("Error: Could not save new folder from Managed Object Context")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }        //loadData()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

}



//MARK: TableView Functions
extension TasksTVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        // Check whether user has started search in search bar
        //        if searchController.active && searchController.searchBar.text != "" {
        //            return filteredFolders.count
        //        } else {
        //            return folders.count
        //        }
        
        
        
        //print("subFolders.count = \(tasks.count)")
        
        
        return objArray.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // Clear tasks
        var selectedTask: Task? = nil
        var selectedSubTask: SubTask? = nil
        
        /* 
            pseudo code
         
            1. is of class task?
                T. has sub tasks?
                    T. already expanded/showing?
                        T. collapseCells()
                        F. expandCells()
                    F. do nothing - nothing to show
                F. is of class sub task?
                    T. do nothing - no plans for sub sub tasks at this stage
                    F. catch error
         
            How determine if already expanded? Search dataArray for their presence? and search the index for their presence?
         
         
         
         */
        
        if objArray[indexPath.row].isKindOfClass(Task){
            selectedTask = objArray[indexPath.row] as? Task
            
            if selectedTask?.subTasks?.count > 0 {
                
                var cellIsExpanded = false
                

                // Check objArray to see if all the subtasks are there.
                for item in (selectedTask?.subTasks)! {
                    if !objArray.contains(item as! NSManagedObject) {
                        print("The subtask isn't there")
                    } else {
                        cellIsExpanded = true
                        print("found it!")
                        break
                    }
                }
                
                if !cellIsExpanded {
                    expandCellsFromIndexOf(selectedTask!, indexPath: indexPath, tableView: tableView)
                } else {
                    collapseCellsFromIndexOf(selectedTask!, indexPath: indexPath, tableView: tableView)
                    
                    
                    print("Nothing to expand bro")
                }

                
                
                //objArray.contains(<#T##element: NSManagedObject##NSManagedObject#>)
                
                
                
            }
            
//            
//            
//            // Get array of SubTasks OR do I even need one?
//            guard let objToInsert = selectedTask?.subTasks else {
//                print("Task has no subtasks")
//                return
//            }
//            
//            var i = 0
//            
//            // Update the datasource
//            for item in objToInsert {
//                objArray.insert(item as! NSManagedObject, atIndex: indexPath.row+1+i)
//                i += 1
//            }
//            
//            let expandedRange = NSMakeRange(indexPath.row, i)
//            
//            //print("expandedRange.location = \(expandedRange.location)")
//            
//            var indexPaths = [NSIndexPath]()
//            
//
//            
//            for i in 0..<objToInsert.count {
//                //print("i.title = \()")
//                indexPaths.append(NSIndexPath.init(forRow: indexPath.row+i+1, inSection: 0))
//
//
//            }
//            
//            
//            
//            // Insert the rows
//            self.tableView.beginUpdates()
//
//            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
//            self.tableView.endUpdates()
            
            
        } else if objArray[indexPath.row].isKindOfClass(SubTask){
            selectedSubTask = objArray[indexPath.row] as? SubTask
        }
    
        

        
    }
    
    //FIXME: May need to change this from a Task to an NSManagedObject at some point
    func collapseCellsFromIndexOf(selectedTask: Task,indexPath:NSIndexPath,tableView:UITableView){
        
        let end = indexPath.row + 1 + (selectedTask.subTasks?.count)!
        let start = indexPath.row + 1
        let collapseRange =  Range(start: start, end: end)
        
        
        // Get array of SubTasks OR do I even need one?
        guard let objToRemove = selectedTask.subTasks else {
            print("Task has no subtasks")
            return
        }
        
        // Update the datasource
        objArray.removeRange(collapseRange)
        
        var indexPaths = [NSIndexPath]()
        
        //let i = 0
        for i in 0..<objToRemove.count {
            //print("i.title = \()")
            indexPaths.append(NSIndexPath.init(forRow: indexPath.row+i+1, inSection: 0))
            
            
        }
        dispatch_async(dispatch_get_main_queue()) {
            // Insert the rows
            self.tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
        

        
    }
    
    func expandNewCellsFromIndexOf(selectedTask: Task,indexPath:NSIndexPath,tableView:UITableView){
        
    
    }
    
    
    //FIXME: May need to change this from a Task to an NSManagedObject at some point
    func expandCellsFromIndexOf(selectedTask: Task,indexPath:NSIndexPath,tableView:UITableView){
        
        
        // Get array of SubTasks OR do I even need one?
//        guard let objToInsert = selectedTask.subTasks else {
//            print("Task has no subtasks")
//            return
//        }
        

        
        // Update the datasource
        
        //print("objToInsert.count = \(objToInsert.count)")
        
        
        /*
            Are any subtasks in objArray?
                T.  Insert ONLY new ones and append them to the end of current subtasks
                F.  Insert ALL subtasks
         
         
         
         
         */
        
        var i = 0
        
        var numObjToInsert = 0
        
        for item in selectedTask.subTasks! {
            
            
            for _ in objArray {
                if !objArray.contains(item as! NSManagedObject) {
                    objArray.insert(item as! NSManagedObject, atIndex: indexPath.row+1+i)
                    i += 1
                    
                    numObjToInsert += 1
                    
                    print("i = \(i)")
                } else {

                }
                

            }
            
            

        }
        
        //let expandedRange = NSMakeRange(indexPath.row, i)
        
        //print("expandedRange.location = \(expandedRange.location)")
        
        var indexPaths = [NSIndexPath]()
        
        print("numObjToInsert.count = \(numObjToInsert)")
        
        for i in 0..<numObjToInsert {
            //print("i.title = \()")
            indexPaths.append(NSIndexPath.init(forRow: indexPath.row+i+1, inSection: 0))
            
            
        }
        
        
        // Insert the rows
        dispatch_async(dispatch_get_main_queue()) {

            self.tableView.beginUpdates()
            
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var task: NSManagedObject?
        
        //print("indexPath.row = \(indexPath.row)")
        
        
        //print("objArray.count = \(objArray.count)")
        
        if objArray[indexPath.row].isKindOfClass(Task) {
            //print("the row is of Task class")
            task = objArray[indexPath.row] as! Task
            cell.backgroundColor = UIColor.blueColor()
            //cell.textLabel?.text = folder.title
            cell.textLabel?.text = task!.valueForKey("text") as? String


        } else if objArray[indexPath.row].isKindOfClass(SubTask) {
            //print("the row is of SubTask class")
            task = objArray[indexPath.row] as! SubTask
            cell.backgroundColor = UIColor.redColor()
            //cell.textLabel?.text = folder.title
            cell.textLabel?.text = task!.valueForKey("text") as? String
        }
        
        return cell
        
        
    }
    
    
    func deleteTask(indexPath: NSIndexPath) {
        
        let taskToDelete = self.objArray[indexPath.row]
        
        self.moc.deleteObject(taskToDelete)
        print("object should have deleted")
        
        do {
            try self.moc.save()
            let index = objArray.indexOf(taskToDelete)
            objArray.removeAtIndex(index!)
            
        } catch {
            print("Error: Failed to save context after deletng Folder")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            
            print("shit should have reloaded itself....")
        }
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let completeTitleString = "✓ "
        let deleteTitleString = "x "
        
        
        
        
        let complete = UITableViewRowAction(style: .Normal, title: completeTitleString) { action, index in
            print("complete button tapped")
            //TODO: Implement code for completed task
        }
        
        let lightBlue = UIColor(colorLiteralRed: 51/255, green: 100/255, blue: 204/255, alpha: 1.0)
        
        complete.backgroundColor = lightBlue
        
        let delete = UITableViewRowAction(style: .Normal, title: deleteTitleString) { action, index in
            print("delete button tapped")
            
            
            //TODO: Implement delete folder code. Include code for "yes"/"no"
            
            
            
            let addNotebookAlert = UIAlertController(title: "Delete Task?",
                                                     message: nil,
                                                     preferredStyle:UIAlertControllerStyle.Alert)
            
            
            let deleteButton = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (deleteButton) in
                
                self.deleteTask(indexPath)
                
                
                
            })
            
            
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            addNotebookAlert.addAction(deleteButton)
            addNotebookAlert.addAction(cancelButton)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addNotebookAlert, animated: true, completion: nil)
            }
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        let edit = UITableViewRowAction(style: .Normal, title: "Add") { (action, index) in
            //TODO: Code for edit button
            let pT = self.objArray[indexPath.row] as! Task
            self.createSubTask(pT)
            
            self.expandCellsFromIndexOf(self.objArray[indexPath.row] as! Task, indexPath: indexPath, tableView: tableView)
            
        }
        
        edit.backgroundColor = UIColor.orangeColor()
        
        
        return [complete, edit, delete]
    }
    
    
    override func tableView(tableView: UITableView,
                            canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        
    }
}

extension TasksTVC  {
    
    func textFieldChanged(sender: UITextField) {
        
        //http://stackoverflow.com/questions/24474762/check-on-uialertcontroller-textfield-for-enabling-the-button
        
        //self.actionToEnable?.enabled = (sender.text! != "Validation")
        if sender.text != "" {
            self.actionToEnable?.enabled = true
        } else {
            self.actionToEnable?.enabled = false
        }
        
        //return (self.actionToEnable?.enabled)!
    }
}






/*
 
 CODE FOR LATER
 
 // Create index paths for the range
 //FIXEME: WHY DOESN'T MINE WORK?!?
 //            for i in 0..<expandedRange.length {
 //                print("expandedRange.location = \(expandedRange.location)")
 //                //print("expandedRange.length = \(expandedRange.length)")
 //                print("i = \(i)")
 //                print("expandedRange.location + i = \(expandedRange.location + i+1)")
 //
 //                print("indexPath.row+i+1 = \(indexPath.row+i+1)\n")
 //
 //                indexPaths.append(NSIndexPath.init(forRow: expandedRange.location+i+1, inSection: 0))
 //
 //                //indexPaths.append(NSIndexPath(forRow: indexPath.row, inSection: <#T##Int#>)
 //
 //            }
 
 */

