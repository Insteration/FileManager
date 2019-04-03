//
//  StartUpPageViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 4/2/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

fileprivate enum PageViewType: String {
    case first = "FirstStartUpView"
    case second = "SecondStartUpView"
    case third = "ThirdStartUpView"
    case fourth = "FourthStartUpView"
}

class FileManagerStartUpPageViewController: UIPageViewController {
    
    let userDefaultSet = FileManagerUserDefaultsSettings()
    
    private (set) lazy var startUpOrderedViewControllers: [UIViewController] = {
        return [
            self.newStartUpView(.first),
            self.newStartUpView(.second),
            self.newStartUpView(.third),
            self.newStartUpView(.fourth)
        ]
    }()
    
    var currentIndex: Int {
        get {
            return startUpOrderedViewControllers.firstIndex(of: viewControllers!.first!)!
        }
        set {
            guard newValue >= 0, newValue < startUpOrderedViewControllers.count else {
                return
            }
            let vc = startUpOrderedViewControllers[newValue]
            let direction: UIPageViewController.NavigationDirection = newValue > currentIndex ? .forward: .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .gray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaultSet.userDefaults.set(1, forKey: "startUpKey")
        
        dataSource = self
        
        if let firstViewController = startUpOrderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func newStartUpView(_ viewType: PageViewType) -> UIViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewType.rawValue)
        return vc!
    }
}

extension FileManagerStartUpPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard startUpOrderedViewControllers.count > previousIndex else {
            return nil
        }
        return startUpOrderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        guard startUpOrderedViewControllers.count != nextIndex else {
            return nil
        }
        guard startUpOrderedViewControllers.count > nextIndex else {
            return nil
        }
        return startUpOrderedViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return startUpOrderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = viewControllers!.firstIndex(of: firstViewController) else {
            return 0 }
        return firstViewControllerIndex
    }
}
