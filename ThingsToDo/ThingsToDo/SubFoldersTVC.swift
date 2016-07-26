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
    
    
    //let searchController = UISearchController(searchResultsController: nil) //FIXME: argument of nil means use current view i think???
    
    var filteredSubFolders = [SubFolder]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO: Reference code. Delete once done.
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // -- Setup navigation bar appearance
        self.navigationItem.title = "Things To Do"  //TODO: Should this say something like "Folders?" or should that be an informal name?
        
        
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
        
        let newSubFolder = NSManagedObject(entity: entity, insertIntoManagedObjectContext: moc)
        
        newSubFolder.setValue(title, forKey: "title")
        newSubFolder.setValue(NSDate(), forKey: "creationDate")
        newSubFolder.setValue(false, forKey: "isComplete")
        newSubFolder.setValue(false, forKey: "isHot")
        newSubFolder.setValue(nil, forKey: "dueDateTime")
        //newSubFolder.setValue(false, forKey: "folder")
        
        
        
        
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
        
        // Set the Managed Object Context
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "SubFolder")
        
        
        //3
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            subFolders = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        } catch {
            print("some other error")
        }
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
