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
    var tasks = [NSManagedObject]()
    var task: Task?
    var subFolder: SubFolder?
    
    //let searchController = UISearchController(searchResultsController: nil) //FIXME: argument of nil means use current view i think???
    
    var filteredSubFolders = [SubFolder]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set the Managed Object Context
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        //fetchRequest.predicate = NSPredicate(format: "title = %@", argumentArray: ["jim"])
        
        //FIXME: what is this doing?
        if subFolder?.title != nil {
            print("it's not nil!!!")
            self.navigationItem.title = subFolder!.title
            
        } else {
            print("subfolder is NIL!!")
        }
        
        let pred = NSPredicate(format: "subFolder == %@", subFolder!)
        
        
        
        fetchRequest.predicate = pred
        
        
        
        //3
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            tasks = results as! [NSManagedObject]
            print("subFolders.count = \(tasks.count)")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } catch {
            print("some other error")
        }
        
        
        //TODO: Reference code. Delete once done.
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // -- Setup navigation bar appearance
        //self.navigationItem.title = "Things To Do"  //TODO: Should this say something like "Folders?" or should that be an informal name?
        
        
        let addFolderButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TasksTVC.addTask))
        //let searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(SubFoldersTVC.search))
        let addDueDateTimeButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: #selector(TasksTVC.addDueDateTime)) //TODO: Get a better menu picture
        
        let rightBarButtonItemArray = [ addFolderButtonItem, addDueDateTimeButtonItem ]
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItemArray
        //self.navigationItem.leftBarButtonItem = addDueDateTimeButtonItem
        
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func addDueDateTime(){
        
    }
    
    func addTask() {
        
        // Creat Alert Controller
        let alertController = UIAlertController(title: "Add Task", message: "Enter Task title", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add TextField to the Alert Controller
        
        //print("folder.title = \(subFolder?.folder)")
        
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), forControlEvents: .EditingChanged)
        }
        
//        
//        func textFieldChanged(){
//            
//        }
        
        // Create the Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled
            print("User cancelled the new Task")
        }
        
        // Create the Add button
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            print("Should have made the new Task")
            
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
        
        
        do{
            try moc.save()
            tasks.append(newTask)
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        // Check whether user has started search in search bar
        //        if searchController.active && searchController.searchBar.text != "" {
        //            return filteredFolders.count
        //        } else {
        //            return folders.count
        //        }
        
        
        
        print("subFolders.count = \(tasks.count)")
        
        
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Implement code for when users select a row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var task: Task
        
        task = tasks[indexPath.row] as! Task
        
        
        
        //cell.textLabel?.text = folder.title
        cell.textLabel?.text = task.valueForKey("text") as? String
        
        
        
        cell.backgroundColor = UIColor.blueColor()
        
//        if (cell.textLabel?.text = "test cell") != nil{
//            print("textLabel is not nil")
//        }
        
        return cell
        
        
    }
    
    
    func deleteTask(indexPath: NSIndexPath) {
        
        let taskToDelete = self.tasks[indexPath.row]
        
        self.moc.deleteObject(taskToDelete)
        print("object should have deleted")
        
        do {
            try self.moc.save()
            let index = tasks.indexOf(taskToDelete)
            tasks.removeAtIndex(index!)
            
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
        
        let edit = UITableViewRowAction(style: .Normal, title: "edit") { (action, index) in
            //TODO: Code for edit button
            print("User pressed the edit button")
            
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