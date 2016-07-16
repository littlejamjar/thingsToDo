//
//  TransitioningObject.swift
//  ThingsToDo
//
//  Created by james wikaira on 15/07/16.
//  Copyright © 2016 james wikaira. All rights reserved.
//


// -- Source: http://stackoverflow.com/questions/5161730/iphone-how-to-switch-tabs-with-an-animation

import UIKit

class TransitioningObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    // --   Custom properties to determine which direction screens scrolling from.
    var fromViewTag: Int?
    var toViewTag: Int?
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Get references for both views
        let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // Starting x-axis co-ordinate for 'toView'
        var xPosition: CGFloat
        let viewSize: CGRect = fromView.frame

        if fromViewTag < toViewTag {    // fromView tab is to LEFT of toView
            //xPosition = 320 //FIXME: Why is this 320?
            xPosition = viewSize.size.width
            
            print("1 xPosition = \(xPosition)")
            
        } else {
            xPosition = viewSize.size.width * -1
            print("2 xPosition = \(xPosition)")

        }
        
        guard let superView = fromView.superview else {
            print("Error: Could not find super view..")
            return
        }
        
        // Add to view to the super view
        superView.addSubview(toView)
        
        // Get the frame size of the fromView
        
        
        // Position the 'toView' off the screen to the right.
        toView.frame = CGRectMake(xPosition, viewSize.origin.y, viewSize.size.width, viewSize.size.height)
        
        // This function deals with the actual transition.
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
                //  Function argument breakdown
                //  - delay                     -> Amount of time in seconds before the transition starts
                //  - usingSpringWithDamping    -> Amount the screen 'bounces'. The higher the number the greater the damping, i.e. the less the 'bounce'
                //  - initialSpringVelocity     -> Does seem to make much of a difference unless set to very high numbers.
                //  - options                   -> This doesn't seem to make a difference as it never gets used. Have experimented with changing it and it shows no difference. This code below makes use of the 'options' argument. It doesn't allow the push style transition we're after, though. Will keep it here for reference.
                //  EXAMPLE: 
                        //UIView.transitionFromView(fromView, toView: toView, duration: self.transitionDuration(transitionContext), options:                                                                          UIViewAnimationOptions.TransitionCrossDissolve) { finished in transitionContext.completeTransition(true)}
            
            
            
                //  Note that x-axis coordinates are inverted in the below example
                fromView.frame = CGRectMake(xPosition * -1, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                toView.frame = CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
            
            }) { (finished) in
                //fromView.removeFromSuperview()    //FIXME: This doesn't seem to do anything. Why is it here?
                transitionContext.completeTransition(finished)
        }
     }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}

