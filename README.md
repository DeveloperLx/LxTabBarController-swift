# LxTabBarController-swift
	Inherited from UITabBarController. To change UITabBarController interactive mode, LxTabBarController add a powerful gesture you can switch view controller by sweeping screen from left the right or right to left.
	
*	![demo](demo.gif)


Installation
------------
    You only need drag LxTabBarController.swift to your project.
    
Support
------------
    Minimum support iOS version: iOS 7.0

Usage
----------
`Use LxTabBarController as same as UITabBarController.`

	let vc1 = ViewController()
    vc1.title = "vc1"
    let nc1 = UINavigationController(rootViewController: vc1)
    
    let vc2 = ViewController()
    vc2.title = "vc2"
    let nc2 = UINavigationController(rootViewController: vc2)
    
    let vc3 = ViewController()
    vc3.title = "vc3"
    let nc3 = UINavigationController(rootViewController: vc3)
    
    let vc4 = ViewController()
    vc4.title = "vc4"
    let nc4 = UINavigationController(rootViewController: vc4)
    
    let tabBarController = LxTabBarController()
    tabBarController.viewControllers = [nc1, nc2, nc3, nc4]

BE CAREFUL!
-----------

	The gesture for switching tab has risk to cause conflict to other gestures, you can set tabBarController.panToSwitchGestureRecognizerEnabled = false to forbid it.
    
License
-----------
    LxTabBarController is available under the Apache License 2.0. See the LICENSE file for more info.