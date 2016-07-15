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
        let fromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        //transitionContext.containerView()!.addSubview(fromView)
        //transitionContext.containerView()!.addSubview(toView)
        
        let option = UIViewAnimationOptions.TransitionFlipFromLeft
        
        UIView.transitionFromView(fromView, toView: toView, duration: transitionDuration(transitionContext), options: option) { finished in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
}

//
//// MARK: UIViewControllerAnimatedTransitioning protocol methods
//
//// animate a change from one viewcontroller to another
//func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//    
//    // get reference to our fromView, toView and the container view that we should perform the transition in
//    let container = transitionContext.containerView()!
//    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
//    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
//    
//    // set up from 2D transforms that we'll use in the animation
//    let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
//    let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
//    
//    // start the toView to the right of the screen
//    //toView.transform = offScreenRight
//    toView.transform = offScreenLeft
//    
//    
//    // add the both views to our view controller
//    container.addSubview(toView)
//    container.addSubview(fromView)
//    
//    // get the duration of the animation
//    // DON'T just type '0.5s' -- the reason why won't make sense until the next post
//    // but for now it's important to just follow this approach
//    let duration = self.transitionDuration(transitionContext)
//    
//    // perform the animation!
//    // for this example, just slid both fromView and toView to the left at the same time
//    // meaning fromView is pushed off the screen and toView slides into view
//    // we also use the block animation usingSpringWithDamping for a little bounce
//    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.LayoutSubviews, animations: {
//        
//        //fromView.transform = offScreenLeft
//        
//        fromView.transform = offScreenRight
//        
//        toView.transform = CGAffineTransformIdentity
//        
//        }, completion: { finished in
//            
//            // tell our transitionContext object that we've finished animating
//            transitionContext.completeTransition(true)
//            
//    })
//    
//    
//    
//}
//
//// return how many seconds the transiton animation will take
//func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//    return 0.5
//}
//
//// MARK: UIViewControllerTransitioningDelegate protocol methods
//
//// return the animator when presenting a viewcontroller
//// remember that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
//func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    return self
//}
//
//// return the animator used when dismissing from a viewcontroller
//func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//    return self
//}
//