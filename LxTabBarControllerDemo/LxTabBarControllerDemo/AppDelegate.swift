//
//  AppDelegate.swift
//  LxTabBarControllerDemo
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

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
        window?.rootViewController = tabBarController
        
        return true
    }
}

