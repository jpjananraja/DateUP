//
//  ViewController.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/5/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import UIKit

//Global constant
let pageController = ViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)



class ViewController: UIPageViewController, UIPageViewControllerDataSource
{
    let cardsVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as UIViewController
    
    let profileVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileNavController") as UIViewController

    let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController") as UIViewController

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.view.addSubview(CardView(frame: CGRectMake(80.0, 20.0, 120.0, 200.0)))
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.dataSource = self
        
        self.setViewControllers([cardsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Helper functions
    func gotoNextVC()
    {
        //self.viewControllers[0] refers to the current View Controller loaded on the screen through a pageViewController
        
        let nextVC = self.pageViewController(self, viewControllerAfterViewController: self.viewControllers[0] as UIViewController)!
        self.setViewControllers([nextVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    
    func gotoPreviousVC()
    {
        //self.viewControllers[0] refers to the current View Controller loaded on the screen through a pageViewController
        
        let previousVC = self.pageViewController(self, viewControllerBeforeViewController: self.viewControllers[0] as UIViewController)!
        self.setViewControllers([previousVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
    
    
    
    //MARK:- UIPageViewControllerDataSource methods
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        switch viewController
        {
            case cardsVC:
                return profileVC
            case profileVC:
                return nil
            case matchesVC:
                return cardsVC
            default:
                return nil
        }
        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        switch viewController
        {
//            case cardsVC:
//                return nil
            case cardsVC:
                return matchesVC
            case profileVC:
                return cardsVC
            default:
                return nil
            
        }
        
    }
    


}

