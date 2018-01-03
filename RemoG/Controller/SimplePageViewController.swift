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
        get {
            return viewControllers!.first!
        } set(newPresentedController) {
            set(presentedController: newPresentedController, animated: false)
        }
    }
    var presentedControllerIndex: Int {
        get {
            return allViewControllers.index(of: presentedController)!
        } set(newIndex) {
            set(presentedControllerIndex: newIndex, animated: false)
        }
    }
    
    var pageControl: UIPageControl? {
        return view.subviews.first { $0 is UIPageControl } as! UIPageControl?
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
        
        dataSource = self
        setViewControllers(
            [allViewControllers[0]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
    
    func set(presentedController newPresentedController: UIViewController, animated: Bool) {
        assert(
            allViewControllers.contains(newPresentedController),
            "Can't present view controller '\(newPresentedController)', because " +
            "it isn't one of the SimplePageViewController's view controllers (in allViewControllers)."
        )
        
        set(
            presentedController: newPresentedController,
            index: allViewControllers.index(of: newPresentedController)!,
            animated: animated
        )
    }
    
    func set(presentedControllerIndex newIndex: Int, animated: Bool) {
        assert(
            newIndex >= 0 && newIndex < allViewControllers.count,
            "Can't present view controller with index '\(newIndex)', because " +
            "it's out of bounds (SimplePageViewController contains \(allViewControllers.count) view controllers)"
        )
        
        set(
            presentedController: allViewControllers[newIndex],
            index: newIndex,
            animated: animated
        )
    }
    
    private func set(
        presentedController newPresentedController: UIViewController,
        index: Int,
        animated: Bool
    ) {
        let indexOffset = index - presentedControllerIndex
        
        if indexOffset != 0 { //Otherwise no need to change
            let direction =
                (indexOffset > 0) ?
                UIPageViewControllerNavigationDirection.forward :
                UIPageViewControllerNavigationDirection.reverse
            
            setViewControllers(
                [newPresentedController],
                direction: direction,
                animated: animated,
                completion: nil
            )
        }
    }
    
    // MARK: - Page view data source
    
    /*func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return presentedControllerIndex
    }*/
    
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
