//
//  SimplePageViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class SimplePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    let allViewControllers: [UIViewController]
    
    var presentedController: UIViewController {
        return viewControllers!.first!
    }
    var presentedControllerIndex: Int {
        return allViewControllers.index(of: presentedController)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("Loading SimplePageViewController from coder unsupported")
    }

    init(
        allViewControllers: [UIViewController],
        transitionStyle style: UIPageViewControllerTransitionStyle,
        navigationOrientation: UIPageViewControllerNavigationOrientation = .horizontal,
        options: [String : Any]? = nil
    ) {
        self.allViewControllers = allViewControllers
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        
        self.dataSource = self
        self.setViewControllers(
            [allViewControllers[0]],
            direction: .forward,
            animated: false,
            completion: { _ in }
        )
    }
    
    // MARK: - Page view data source
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return presentedControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let newIndex = allViewControllers.index(before: presentedControllerIndex)
        
        if newIndex < 0 {
            return nil
        } else {
            return allViewControllers[newIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let newIndex = allViewControllers.index(after: presentedControllerIndex)
        
        if newIndex >= allViewControllers.count {
            return nil
        } else {
            return allViewControllers[newIndex]
        }
    }
}
