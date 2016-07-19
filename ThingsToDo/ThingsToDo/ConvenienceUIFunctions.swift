//
//  CustomViewFunctions.swift
//  ThingsToDo
//
//  Created by james wikaira on 18/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit

extension FoldersTVC {
    
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


