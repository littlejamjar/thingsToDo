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
    //var task: Task?
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
    
        
        let addTaskButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TasksTVC.addTask))
        //let searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(SubFoldersTVC.search))
        let addDueDateTimeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: #selector(TasksTVC.createSubTask)) //TODO: Get a better menu picture
        
        let rightBarButtonItemArray = [ addTaskButtonItem, addDueDateTimeButtonItem ]
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItemArray
    }
    
    func addSubTask(task: Task, indexPath: NSIndexPath){
        // Creat Alert Controller
        let alertController = UIAlertController(title: "Add Sub Task", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        // Create the Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled
            //print("User cancelled the new Task")
        }
        
        // Create the Add button
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            //print("Should have made the new Task")
            
            guard let text = alertController.textFields![0].text else {
                print("No title")
                return
            }
            
            self.createSubTask(indexPath, text: text)
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
    
    func createSubTask(indexPath: NSIndexPath, text: String){
        
        guard let entity = NSEntityDescription.entityForName("SubTask", inManagedObjectContext: moc) else {
            print("Error: Could not create entity")
            return
        }
        
        let newSubTask = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc) as! SubTask
        let task = objArray[indexPath.row] as! Task
        
        
        newSubTask.text = text
        newSubTask.creationDate = NSDate()
        newSubTask.isComplete = false
        newSubTask.isHot = false
        newSubTask.dueDateTime = nil
        newSubTask.task = task
        
        //objArray.append(newSubTask)    //FIXME: What about this???
        
        do{
            try moc.save()
        } catch {
            print("Error: Could not save new subtask from Managed Object Context")
        }
        
        expandCellsFromIndexOf(task, indexPath: indexPath, tableView: tableView)
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
        
        if objArray[indexPath.row].isKindOfClass(Task){
            selectedTask = objArray[indexPath.row] as? Task
            if selectedTask?.subTasks?.count > 0 {
        
                if !isExpanded(selectedTask!) {
                    expandCellsFromIndexOf(selectedTask!, indexPath: indexPath, tableView: tableView)
                } else {
                    collapseCellsFromIndexOf(selectedTask!, indexPath: indexPath, tableView: tableView)
                }
            }
            
            
        } else if objArray[indexPath.row].isKindOfClass(SubTask){
            // Do nothing
            
            //selectedSubTask = objArray[indexPath.row] as? SubTask
        }
    }
    
    func isExpanded(task: Task) -> Bool {
        
        if task.subTasks?.count == 0 {
            return false
        }
        
        for _ in objArray {
            for sub in task.subTasks! {
                if objArray.contains(sub as! NSManagedObject) {
                    return true
                }
            }
        }
        return false
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
    
//    func expandNewCellsFromIndexOf(selectedTask: Task,indexPath:NSIndexPath,tableView:UITableView){
//        
//    
//    }
    
    
    //FIXME: May need to change this from a Task to an NSManagedObject at some point
    func expandCellsFromIndexOf(selectedTask: Task,indexPath:NSIndexPath,tableView:UITableView){
        
        
        var i = 0
        
        var numObjToInsert = 0
        
        
        for item in selectedTask.subTasks! {
            
            print("item.text = \((item as! SubTask).text)")
            
            
            for _ in objArray {
                

                if !objArray.contains(item as! NSManagedObject) {
                    print("indexPath.row+1+i = \(indexPath.row+1+i)")
                    objArray.insert(item as! NSManagedObject, atIndex: indexPath.row+1+i)
                    print("i = \(i)")

                    numObjToInsert += 1
                    print("numObjToInsert = \(numObjToInsert)")
                    i += 1

                    
                } else {
                    i += 1
                }
            }
        }
        
        var indexPaths = [NSIndexPath]()
        
        for i in 0..<numObjToInsert {
            print("indexPath.row+1+i = \(indexPath.row+1+i)")
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
        
        var selectedTask: Task? = nil
        var selectedSubTask: SubTask? = nil
        
        
        if objArray[indexPath.row].isKindOfClass(Task) {
            selectedTask = objArray[indexPath.row] as? Task
            cell.backgroundColor = UIColor.blueColor()
            cell.textLabel?.text = selectedTask?.text
            
    

        } else if objArray[indexPath.row].isKindOfClass(SubTask) {
            selectedSubTask = objArray[indexPath.row] as? SubTask
            cell.backgroundColor = UIColor.redColor()
            cell.textLabel?.text = selectedSubTask?.text
        }
        
        return cell
        
        
    }
    
    
    func deleteObj(indexPath: NSIndexPath) {   //FIXME: Update the name to deleteObj

        let obj = self.objArray[indexPath.row]

        
        if  obj.isKindOfClass(Task) &&
            (obj as! Task).subTasks?.count > 0 &&
            isExpanded(obj as! Task){
            self.collapseCellsFromIndexOf(obj as! Task, indexPath: indexPath, tableView: self.tableView)
        }
        
        var indexPaths = [NSIndexPath]()
        indexPaths.append(NSIndexPath(forRow: indexPath.row, inSection: 0))
        
        self.moc.deleteObject(obj)
        
        do {
            try self.moc.save()



        
        } catch {
            print("Error: Failed to save context after deletng Folder")
        }
    

        
        
        // Insert the rows
        dispatch_async(dispatch_get_main_queue()) {
            
            // Need to remove the obj here because the previous collapseCellsFromIndexOf() call might not yet have completed on the main queue
            self.objArray.removeAtIndex(self.objArray.indexOf(obj)!)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var task: Task?
        let subTask: SubTask?
        
        
        let completeTitleString = "✓ "
        let deleteTitleString = "x "
        
        let lightBlue = UIColor(colorLiteralRed: 51/255, green: 100/255, blue: 204/255, alpha: 1.0)

        var buttons = [UITableViewRowAction]()
        
        /*
            Buttons per row
         
            1. Complete 
                        - mark task/sub task as completed
                        - make visual change to the row to indicate it is complete
                        - implement some type of comment function
         */
        
        
        /*  
         *  "Complete" button
         */
        
        
        //  "Complete" - action
        let complete = UITableViewRowAction(style: .Normal, title: completeTitleString) { action, index in
            print("TODO: Implement code for when user completes a task/subtask")
            //TODO: Implement code for completed task
        }
        
        // "Complete" - appearance
        complete.backgroundColor = lightBlue
        
        buttons.append(complete)
        
        /*
         *  "Delete" button
         */
        
        
        // "Delete" - action
        let delete = UITableViewRowAction(style: .Normal, title: deleteTitleString) { action, index in
            let addNotebookAlert = UIAlertController(title: "Delete?",
                                                     message: nil,
                                                     preferredStyle:UIAlertControllerStyle.Alert)
            let deleteButton = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (deleteButton) in
                
                self.deleteObj(indexPath)
            })
            
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            addNotebookAlert.addAction(deleteButton)
            addNotebookAlert.addAction(cancelButton)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addNotebookAlert, animated: true, completion: nil)
            }
        }
        
        // "Delete" - appearance
        delete.backgroundColor = UIColor.redColor()
        
        
        buttons.append(delete)
        
        /*
         *  "Add" button
         *
         *  - for Tasks only
         */
        
        if objArray[indexPath.row].isKindOfClass(Task) {
            // "Add" - action
            let add = UITableViewRowAction(style: .Normal, title: "Add") { (action, index) in
                //TODO: Code for edit button
                
                task = self.objArray[indexPath.row] as? Task
                self.addSubTask(task!, indexPath: index)


                
                //self.createTask(title)
                
                
                //self.createSubTask(pT)
//                dispatch_async(dispatch_get_main_queue()){
//                    self.expandCellsFromIndexOf(task!, indexPath: indexPath, tableView: tableView)
//                }
                
            }
            
            // "Add" - appearance
            add.backgroundColor = UIColor.orangeColor()
            
            buttons.append(add)
        }

        
        return buttons
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

