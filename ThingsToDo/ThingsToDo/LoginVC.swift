//
//  ViewController.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//


import UIKit
import Foundation


class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signInBtn(sender: UIButton) {
        self.performSegueWithIdentifier("showTabBarVC", sender: nil)

        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // code prior to segueing if any is required
    }
    
}

