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
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Get references for both views
        let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //let tabBarController = TabBarViewController()
        
        guard let superView = fromView.superview else {
            print("Error: Could not find super view..")
            return
        }
        
        // Add to view to the super view
        superView.addSubview(toView)
        
        // Get the frame size of the fromView
        let viewSize: CGRect = fromView.frame
        
        //    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;

        // Determine whether we are scrolling right or left.
        let scrollRight = true

        // Position the 'toView' off the screen to the right.
        toView.frame = CGRectMake((scrollRight ? 320 : -320), viewSize.origin.y, 320, viewSize.size.height)
        
        // This function deals with the actual transition.
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
                //  Function argument breakdown
                //  - delay                     -> Amount of time in seconds before the transition starts
                //  - usingSpringWithDamping    -> Amount the screen 'bounces'. The higher the number the greater the damping, i.e. the less the 'bounce'
                //  - initialSpringVelocity     -> Does seem to make much of a difference unless set to very high numbers.
                //  - options                   -> This doesn't seem to make a difference as it never gets used. Have experimented with changing it and it shows no difference. This code below makes use of the 'options' argument. It doesn't allow the push style transition we're after, though. Will keep it here for reference.
                //  EXAMPLE: 
                        //UIView.transitionFromView(fromView, toView: toView, duration: self.transitionDuration(transitionContext), options:                                                                          UIViewAnimationOptions.TransitionCrossDissolve) { finished in transitionContext.completeTransition(true)}
            
            
                fromView.frame = CGRectMake((scrollRight ? -320 : 320), viewSize.origin.y, 320, viewSize.size.height);
                toView.frame = CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
            
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

