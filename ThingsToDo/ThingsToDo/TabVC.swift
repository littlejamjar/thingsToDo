//
//  TabVC.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let foldersTabBarItem = UITabBarItem(title: "Folders", image: nil, tag: 0)
        
        self.tabBarItem = foldersTabBarItem
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
