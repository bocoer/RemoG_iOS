//
//  TabPageNavigationController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/30/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class TabPageViewController: UIViewController, UITabBarDelegate, UIPageViewControllerDelegate {
    let viewControllers: [UIViewController]
    let subTabBar: UITabBar
    let pageViewController: SimplePageViewController
    
    required init?(coder: NSCoder) {
        fatalError("Loading TabPageViewController from coder unsupported")
    }
    
    init(
        viewControllers: [UIViewController],
        transitionStyle style: UIPageViewControllerTransitionStyle,
        navigationOrientation: UIPageViewControllerNavigationOrientation = .horizontal,
        options: [String : Any]? = nil
    ) {
        self.viewControllers = viewControllers
        self.pageViewController = SimplePageViewController(
            allViewControllers: viewControllers,
            transitionStyle: style,
            navigationOrientation: navigationOrientation,
            options: options
        )
        subTabBar = UITabBar()
        super.init(nibName: nil, bundle: nil)
        
        pageViewController.delegate = self
        subTabBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subTabBar.items = viewControllers.map { $0.tabBarItem }
        subTabBar.selectedItem = viewControllers.first?.tabBarItem
        
        pageViewController.pageControl?.isHidden = true
        
        pageViewController.view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        subTabBar.autoresizingMask = [
            UIViewAutoresizing.flexibleTopMargin,
            UIViewAutoresizing.flexibleWidth
        ]
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(subTabBar)
    }
    
    override func viewWillLayoutSubviews() {
        updateChildSizes()
    }
    
    private func updateChildSizes() {
        subTabBar.sizeToFit() //Makes tab bar correct size
        
        pageViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height - subTabBar.frame.height
        )
        
        subTabBar.frame = CGRect(
            x: 0,
            y: view.bounds.height - subTabBar.frame.height,
            width: view.bounds.width,
            height: subTabBar.frame.height
        )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        assert(pageViewController === self.pageViewController)
        
        let index = self.pageViewController.presentedControllerIndex
        subTabBar.selectedItem = subTabBar.items![index]
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        assert(tabBar == self.subTabBar)
        
        let index = tabBar.items!.index(of: item)!
        pageViewController.set(presentedControllerIndex: index, animated: true)
    }
}
