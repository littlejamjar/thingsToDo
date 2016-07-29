//
//  SubFoldersTVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 23/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//
import UIKit
import CoreData


class SubFoldersTVC: UITableViewController {

    // Property declarations
    var actionToEnable: UIAlertAction?
    var moc: NSManagedObjectContext!
    var subFolders = [NSManagedObject]()
    var subFolder: SubFolder?
    var folder: Folder?
    
    //let searchController = UISearchController(searchResultsController: nil) //FIXME: argument of nil means use current view i think???
    
    var filteredSubFolders = [SubFolder]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set the Managed Object Context
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "SubFolder")
        //fetchRequest.predicate = NSPredicate(format: "title = %@", argumentArray: ["jim"])
        
        //FIXME: what is this doing?
        if folder?.title != nil {
            print("it's not nil!!!")
            self.navigationItem.title = folder!.title
            
        } else {
            print("folder is NIL!!1")
        }
        
        let pred = NSPredicate(format: "folder == %@", folder!)
        
        
        
        fetchRequest.predicate = pred
        
        
        
        //3
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            subFolders = results as! [NSManagedObject]
            print("subFolders.count = \(subFolders.count)")
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
        
        
        let addFolderButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(SubFoldersTVC.addSubFolder))
        //let searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(SubFoldersTVC.search))
        //let menuButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(SubFoldersTVC.showMenu)) //TODO: Get a better menu picture
        
        //let rightBarButtonItemArray = [ addFolderButtonItem, searchButtonItem ]
        
        self.navigationItem.rightBarButtonItems = [addFolderButtonItem]
        //self.navigationItem.leftBarButtonItem = menuButtonItem
        
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        
        self.navigationController!.navigationBar.barTintColor = UIColor.greenColor()
        
    }
    
    func addSubFolder() {
        
        // Creat Alert Controller
        let alertController = UIAlertController(title: "Add Sub Folder", message: "Enter Sub Folder title", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add TextField to the Alert Controller
    
        print("folder.title = \(subFolder?.folder)")
        
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        
        func textFieldChanged(){
            
        }
        
        // Create the Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled
            print("User cancelled the new sub folder")
        }
        
        // Create the Add button
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            print("Should have made the new sub folder")
            
            guard let title = alertController.textFields![0].text else {
                print("No title")
                return
            }
            
            self.createSubFolder(title)
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
    
    
    
    
    func createSubFolder(title: String){
        print("createFolder = \(title)")
        
        guard let entity = NSEntityDescription.entityForName("SubFolder", inManagedObjectContext: moc) else {
            print("Error: Could not create entity")
            return
        }
        
        let newSubFolder = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc) as! SubFolder
        
        
        newSubFolder.title = title
        newSubFolder.creationDate = NSDate()
        newSubFolder.isComplete = false
        newSubFolder.isHot = false
        newSubFolder.dueDateTime = nil
        newSubFolder.folder = folder
        
        
//        newSubFolder.setValue(title, forKey: "title")
//        newSubFolder.setValue(NSDate(), forKey: "creationDate")
//        newSubFolder.setValue(false, forKey: "isComplete")
//        newSubFolder.setValue(false, forKey: "isHot")
//        newSubFolder.setValue(nil, forKey: "dueDateTime")
//        newSubFolder.setValue(NSManagedObject(), forKey: "folder")
        
        
        
        
        do{
            try moc.save()
            subFolders.append(newSubFolder)
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
extension SubFoldersTVC {
    
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
        
        
        
        print("subFolders.count = \(subFolders.count)")
        
        
        return subFolders.count

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Implement code for when users select a row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var subFolder: SubFolder
        
//        if searchController.active && searchController.searchBar.text != "" {
//            folder = filteredFolders[indexPath.row]
//        } else {
//            folder = folders[indexPath.row] as! Folder
//        }
        
        subFolder = subFolders[indexPath.row] as! SubFolder
    
        
        
        //cell.textLabel?.text = folder.title
        cell.textLabel?.text = subFolder.valueForKey("title") as? String
        
        return cell
        
        
    }
    
    
    func deleteSubFolder(indexPath: NSIndexPath) {
        
        let subFolderToDelete = self.subFolders[indexPath.row]
        
        self.moc.deleteObject(subFolderToDelete)
        print("object should have deleted")
        
        do {
            try self.moc.save()
            let index = subFolders.indexOf(subFolderToDelete)
            subFolders.removeAtIndex(index!)
            
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
            
            
            
            let addNotebookAlert = UIAlertController(title: "Delete Sub-folder?",
                                                     message: "All Tasks will also be deleted",
                                                     preferredStyle:UIAlertControllerStyle.Alert)
            
            
            let deleteButton = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (deleteButton) in
                //TODO: Implement code to delete a record
                
                
                self.deleteSubFolder(indexPath)
                
                
                
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

extension SubFoldersTVC  {
    
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
