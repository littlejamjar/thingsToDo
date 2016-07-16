

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // MARK: - Tabbar delegate
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let tranObj = TransitioningObject()
        
        
        //FIXME: Will this affect other transitions???
        
        print("fromVC.tabBarItem.tag = \(fromVC.tabBarItem.tag)")
        print("toVC.tabBarItem.tag = \(toVC.tabBarItem.tag)")
        
        tranObj.fromViewTag = fromVC.tabBarItem.tag
        tranObj.toViewTag = toVC.tabBarItem.tag
        
        return tranObj
    }
}