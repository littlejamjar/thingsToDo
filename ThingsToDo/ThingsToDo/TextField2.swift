//
//  TextField2.swift
//  ThingsToDo
//
//  Created by james wikaira on 18/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//

import UIKit

class CustomeTextField: UITextField, UITextFieldDelegate {
    
    func textFieldChanged(sender: UITextField){
        
        //http://stackoverflow.com/questions/24474762/check-on-uialertcontroller-textfield-for-enabling-the-button
        
        print("Did this even work?")
        
        
        //self.actionToEnable?.enabled = (sender.text! != "Validation")
    }
    
    
    
}
