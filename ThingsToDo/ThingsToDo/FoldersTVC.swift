//
//  FoldersTVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit

class FoldersTVC: UITableViewController, UITabBarControllerDelegate {

    
    var tabBarDelegate: UITabBarControllerDelegate?
    
    
    let transitionManager = TransitionManager()
    
//    //func tabBarController(_ tabBarController: UITabBarController,
//                                     animationControllerForTransitionFrom fromVC: UIViewController,
//                                                                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    func tabBarController(tabBarController: UITabBarController,
                          animationControllerForTransitionFromViewController fromVC: UIViewController,
                          toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("inside the tab bar controller delegate")
        
        return transitionManager
    }
    
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

        tabBarDelegate = self
        
        guard let tbc = self.tabBarController else {
            print("tbc not set.")
            return
        }
        
       // tabBarDelegate?.tabBarController(<#T##tabBarController: UITabBarController##UITabBarController#>, animationControllerForTransitionFromViewController: <#T##UIViewController#>, toViewController: <#T##UIViewController#>)
        
        // -- Setup tab bar appearance
        //FIXME: Appears to be a bug whereby setting
        //                              "self.tabBarItem.title = "desired title"
        //       gets overriden by some other code later on. Will set this in storyboard from now.
                
        //self.tabBarController?.tabBar.barTintColor = UIColor.redColor()
        
//        self.navigationItem.title = @"my title"; sets navigation bar title.
//        
//        self.tabBarItem.title = @"my title"; sets tab bar title.
//        
//        self.title = @"my title"; sets both of these.
        
        
//        self.tabBarItem.title = "Test tab bar name"
//        self.tabBarController?.tabBarItem.title = "what about this one?"
//        
//        let tabBarController = self.tabBarController
//        tabBarController?.tabBarItem.title = "tester"
//        
        
        
        
//        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//        UITabBar *tabBar = tabBarController.tabBar;
//        UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
//        UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
//        UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//        UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
        
        
    }


    func showMenu() {
        //TODO: add code to show the meny pop-up. Ideally it comes down from the button in a pretty way but will accept just a normal pop-up if time pressed.
    }
    
    func addFolder() {
        //TODO: add code to add a new folder
    }
    
    func searchTasks() {
        //TODO: add code so user can search through ALL tasks OR just through the current tasks..OR give the option in the search VC (Search VC should be seperate window...)
    }
    
}


extension FoldersTVC {  //MARK: TableView Functions
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
}


/*
 override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

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
