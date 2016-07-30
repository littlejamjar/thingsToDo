

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // MARK: - Tabbar delegate
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let tranObj = TransitioningObject()
        
        // Set the tags for each view controller so transition object can determine which sway to scroll
        tranObj.fromViewTag = fromVC.tabBarItem.tag
        tranObj.toViewTag = toVC.tabBarItem.tag
        
        return tranObj
    }
}