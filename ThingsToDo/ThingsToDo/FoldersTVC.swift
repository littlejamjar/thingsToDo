//
//  FoldersTVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit
import CoreData


class FoldersTVC: UITableViewController {

    // Property declarations
    var actionToEnable: UIAlertAction?
    var moc: NSManagedObjectContext!
    var folders = [NSManagedObject]()
    
    func showMenu() {
        //TODO: add code to show the meny pop-up. Ideally it comes down from the button in a pretty way but will accept just a normal pop-up if time pressed.
    }
    
    

    func addFolder() {
        
        // Creat Alert Controller
        let alertController = UIAlertController(title: "Add Folder", message: "Enter Folder title", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add TextField to the Alert Controller
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        // Create the Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled 
            print("User cancelled the new folder")
        }
        
        // Create the Add button
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            print("Should have made the new folder")
            
            guard let title = alertController.textFields![0].text else {
                print("No title")
                return
            }
            
            self.createFolder(title)
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
    
    func createFolder(title: String){
        //let newFolder = CoreDataHelper.insertManagedObject("Folder", managedObjectContext: moc) as! Folder
    
        print("createFolder = \(title)")
        
        guard let entity = NSEntityDescription.entityForName("Folder", inManagedObjectContext: moc) else {
            print("Error: Could not create entity")
            return
        }
        
        let newFolder = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc)
        
        newFolder.setValue(title, forKey: "title")
        newFolder.setValue(NSDate(), forKey: "creationDate")
        newFolder.setValue(false, forKey: "isComplete")
        
        do{
            try moc.save()
            folders.append(newFolder)
        } catch {
            print("Error: Could not save new folder from Managed Object Context")
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }        //loadData()
    
    
    }
    
    
    
    
    
    
    func searchTasks() {
        //TODO: add code so user can search through ALL tasks OR just through the current tasks..OR give the option in the search VC (Search VC should be seperate window...)
    }
    
    
    
    
}

//MARK: View Functions
extension FoldersTVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO: Reference code. Delete once done.
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // -- Setup navigation bar appearance
        self.navigationItem.title = "Things To Do"  //TODO: Should this say something like "Folders?" or should that be an informal name?
        
        
        let addFolderButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(FoldersTVC.addFolder))
        let searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(FoldersTVC.searchTasks))
        let menuButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(FoldersTVC.showMenu)) //TODO: Get a better menu picture
        
        let rightBarButtonItemArray = [ addFolderButtonItem,
                                        searchButtonItem ]
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItemArray
        self.navigationItem.leftBarButtonItem = menuButtonItem
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Folder")

        
        //3
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            folders = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
        
//        NSNotificationCenter.defaultCenter().removeObserver(self,
//                                                            name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
//                                                            object: nil)
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self,
//                                                            name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
//                                                            object: managedObjectContext.persistentStoreCoordinator)
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self,
//                                                            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
//                                                            object: managedObjectContext.persistentStoreCoordinator)
//        
//        
//        //Notifications coming from iCloud
//        NSNotificationCenter.defaultCenter().addObserver(self,
//                                                         selector: #selector(FoldersTVC.persistentStoreDidChange),
//                                                         name: NSPersistentStoreCoordinatorStoresDidChangeNotification,
//                                                         object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self,
//                                                         selector: #selector(FoldersTVC.persistentStoreWillChange as (FoldersTVC) -> () -> ()),
//                                                         name: NSPersistentStoreCoordinatorStoresWillChangeNotification,
//                                                         object: moc.persistentStoreCoordinator)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self,
//                                                         selector: #selector(NotebookTableVC.recieveICloudChanges(_:)),
//                                                         name: NSPersistentStoreDidImportUbiquitousContentChangesNotification,
//                                                         object: managedObjectContext.persistentStoreCoordinator)

    }
    
}

//MARK: loadData function
extension FoldersTVC{
    
//    func loadData(){
//        folderArray = [Folder]()
//        
//        folderArray = CoreDataHelper.fetchEntities("Folder", managedObjectContext: self.moc, predicate: nil) as! [Folder]
//        
//        print("inside here")
//        
//        print("folderArray = \(folderArray.count)")
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//        }
//        
//        
//    }
    
}


//MARK: TableView Functions
extension FoldersTVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Implement code for when users select a row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let folder = folders[indexPath.row] as! Folder
        
        cell.textLabel?.text = folder.title
        // or
        
        cell.textLabel?.text = folder.valueForKey("title") as! String
        
        
        
        
         // Configure the cell...
        
        //var text = folderArray[indexPath.row]
        
        //cell.textLabel?.text = text
        
        return cell
     }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let complete = UITableViewRowAction(style: .Normal, title: "Complete") { action, index in
            print("more button tapped")
            
            
            //TODO: Implement code for completed task
            
            
            
        }
        
        let lightBlue = UIColor(colorLiteralRed: 51/255, green: 100/255, blue: 204/255, alpha: 1.0)
        
        complete.backgroundColor = lightBlue
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("favorite button tapped")
            
            
            //TODO: Implement delete folder code. Include code for "yes"/"no"
            
            
            
            let addNotebookAlert = UIAlertController(title: "Are you sure you want this folder?",
                                                     message: "Enter folder title",
                                                     preferredStyle:UIAlertControllerStyle.Alert)
            
            //addNotebookAlert.addAction(UIAlertAction(title: "Add", style: UIAl, handler: nil))
            let deleteButton = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (deleteButton) in
                    //TODO: Implement code to delete a record
                
                    print("Record deleted..")
                }
            )
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            addNotebookAlert.addAction(deleteButton)
            addNotebookAlert.addAction(cancelButton)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addNotebookAlert, animated: true, completion: nil)
            }
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [complete, delete]
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




/*
 // Override to support conditional editing of the table view.
 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 if editingStyle == .Delete {
 // Delete the row from the data source
 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 } else if editingStyle == .Insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
