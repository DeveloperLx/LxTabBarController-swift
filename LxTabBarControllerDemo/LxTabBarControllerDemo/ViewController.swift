//
//  ViewController.swift
//  LxTabBarControllerDemo
//

import UIKit

class ViewController: UIViewController {

    convenience init() {

        self.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: Int(arc4random())%12)!, tag: 0)
        title = tabBarItem.title
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random()) / 0xFFFFFFFF), green: CGFloat(CGFloat(arc4random()) / 0xFFFFFFFF), blue: CGFloat(CGFloat(arc4random()) / 0xFFFFFFFF), alpha: 1)
        
        let label = UILabel()
        label.text = "LxTabBarController " + "\(title!)"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(27)
        view.addSubview(label)
        
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let labelConstraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[label]-30-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["label": label])
        let labelConstraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-90-[label(==48)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["label": label])
    
        view.addConstraints(labelConstraintsH)
        view.addConstraints(labelConstraintsV)
    }
}