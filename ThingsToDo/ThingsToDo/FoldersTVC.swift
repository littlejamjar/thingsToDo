//
//  FoldersTVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit


class FoldersTVC: UITableViewController {

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

//    func showAlert()
//    {
//        let titleStr = "title"
//        let messageStr = "message"
//        
//        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let placeholderStr =  "placeholder"
//        
//        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
//            textField.placeholder = placeholderStr
//            textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
//        })
//        
//        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (_) -> Void in
//            
//        })
//        
//        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
//            let textfield = alert.textFields!.first!
//            
//            //Do what you want with the textfield!
//        })
//        
//        alert.addAction(cancel)
//        alert.addAction(action)
//        
//        self.actionToEnable = action
//        action.enabled = false
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    func textChanged(sender:UITextField) {
//        self.actionToEnable?.enabled = (sender.text! == "Validation")
//    }
    
    

    func showMenu() {
        //TODO: add code to show the meny pop-up. Ideally it comes down from the button in a pretty way but will accept just a normal pop-up if time pressed.
    }
    
    var actionToEnable: UIAlertAction?
    
    
    
    func textChanged(sender: UITextField){
        
        //http://stackoverflow.com/questions/24474762/check-on-uialertcontroller-textfield-for-enabling-the-button
        
        //self.actionToEnable?.enabled = (sender.text! != "Validation")
        print("This shit worked!! = \(sender.text) and enabled = \(sender.enabled)")
        
        if sender.text != "" {
            self.actionToEnable?.enabled = true
        } else {
            self.actionToEnable?.enabled = false
        }
    }
    
    func addFolder() {
        
        let alertController = UIAlertController(title: "Add Folder", message: "Enter Folder title", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
        }
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) in
            //TODO: User cancelled 
            print("User cancelled the new folder")
        }
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alert) in
            //TODO: User cancelled
            print("User cancelled the new folder")
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Set actionToEnable to the addAction Alert Action
        self.actionToEnable = addAction
        addAction.enabled = false

        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    func searchTasks() {
        //TODO: add code so user can search through ALL tasks OR just through the current tasks..OR give the option in the search VC (Search VC should be seperate window...)
    }
    
    
    
    
}

//MARK: TableView Functions
extension FoldersTVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Implement code for when users select a row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
         
         // Configure the cell...
        cell.textLabel?.text = "record"
        
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
