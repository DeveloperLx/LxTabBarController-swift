//
//  LxTabBarController.swift
//  LxTabBarControllerDemo
//

import UIKit

enum LxTabBarControllerInteractionStopReason {

    case Finished, Cancelled, Failed
}

let LxTabBarControllerDidSelectViewControllerNotification = "LxTabBarControllerDidSelectViewControllerNotification"

private enum LxTabBarControllerSwitchType {

    case Unknown, Last, Next
}

let TRANSITION_DURATION = 0.2
private var _switchType = LxTabBarControllerSwitchType.Unknown

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return TRANSITION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView().insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        switch _switchType {
            
        case .Last:
            toViewController.view.frame.origin.x = -toViewController.view.frame.size.width
        case .Next:
            toViewController.view.frame.origin.x = toViewController.view.frame.size.width
        case .Unknown:
            break
        }
        
        UIView.animateWithDuration(TRANSITION_DURATION, animations: { () -> Void in
            
            switch _switchType {
                
            case .Last:
                fromViewController.view.frame.origin.x = fromViewController.view.frame.size.width
            case .Next:
                fromViewController.view.frame.origin.x = -fromViewController.view.frame.size.width
            case .Unknown:
                break
            }
            toViewController.view.frame = transitionContext.containerView().bounds
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class LxTabBarController: UITabBarController,UITabBarControllerDelegate,UIGestureRecognizerDelegate {
   
    var panToSwitchGestureRecognizerEnabled: Bool {
    
        get {
            return _panToSwitchGestureRecognizer.enabled
        }
        set {
            _panToSwitchGestureRecognizer.enabled = newValue
        }
    }
    
    var recognizeOtherGestureSimultaneously = false
    var isTranslating = false
    var panGestureRecognizerBeginBlock = { () -> Void in }
    var panGestureRecognizerStopBlock = { (stopReason: LxTabBarControllerInteractionStopReason) -> Void in }
    
    let _panToSwitchGestureRecognizer = UIPanGestureRecognizer()
    var _interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    convenience init () {
        self.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        setup()
    }
    
    func setup() {
    
        self.delegate = self
        
        _panToSwitchGestureRecognizer.addTarget(self, action: "panGestureRecognizerTriggerd:")
        _panToSwitchGestureRecognizer.delegate = self
        _panToSwitchGestureRecognizer.cancelsTouchesInView = false
        _panToSwitchGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(_panToSwitchGestureRecognizer)
    }
    
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
     
        return animationController is Transition ? _interactiveTransition : nil
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return Transition()
    }
    
    func panGestureRecognizerTriggerd(pan: UIPanGestureRecognizer) {
    
        var progress = pan.translationInView(pan.view!).x / pan.view!.bounds.size.width
        
        if progress > 0 {
            _switchType = .Last
        }
        else if progress < 0 {
            _switchType = .Next
        }
        else {
            _switchType = .Unknown
        }
        
        progress = abs(progress)
        progress = max(0, progress)
        progress = min(1, progress)
        
        switch pan.state {
            
        case .Began:
            isTranslating = true
            _interactiveTransition = UIPercentDrivenInteractiveTransition()
            switch _switchType {
                
            case .Last:
                selectedIndex = max(0, selectedIndex - 1)
                selectedViewController = viewControllers![selectedIndex] as? UIViewController
                panGestureRecognizerBeginBlock()
            case .Next:
                selectedIndex = min(viewControllers!.count, selectedIndex + 1)
                selectedViewController = viewControllers![selectedIndex] as? UIViewController
                panGestureRecognizerBeginBlock()
            case .Unknown:
                break
            }
        case .Changed:
            _interactiveTransition?.updateInteractiveTransition(CGFloat(progress))
        case .Failed:
            isTranslating = false
            panGestureRecognizerStopBlock(.Failed)
        default:
            
            if abs(progress) > 0.5 {
                
                _interactiveTransition?.finishInteractiveTransition()
                panGestureRecognizerStopBlock(.Finished)
            }
            else {
                _interactiveTransition?.cancelInteractiveTransition()
                panGestureRecognizerStopBlock(.Cancelled)
            }
            
            _interactiveTransition = nil
            isTranslating = false
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _panToSwitchGestureRecognizer {
            
            return !isTranslating
        }
        else {
            return true
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == _panToSwitchGestureRecognizer || otherGestureRecognizer == _panToSwitchGestureRecognizer {
        
            return recognizeOtherGestureSimultaneously
        }
        else {
            return false
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        let viewControllerIndex = find(tabBarController.viewControllers as! [UIViewController], viewController)
        
        if viewControllerIndex > selectedIndex {
            _switchType = .Next
        }
        else if viewControllerIndex < selectedIndex {
            _switchType = .Last
        }
        else {
            _switchType = .Unknown
        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(LxTabBarControllerDidSelectViewControllerNotification, object: nil)
    }
}
