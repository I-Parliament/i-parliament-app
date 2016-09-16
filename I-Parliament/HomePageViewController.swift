//
//  HomePageViewController.swift
//  I-Parliament
//
//  Created by Kabir Oberai on 16/09/16.
//  Copyright © 2016 I-Parliament. All rights reserved.
//

import UIKit

class HomePageViewController: UIPageViewController {
	
	var items = [
		InfoItem(image: #imageLiteral(resourceName: "Logo"), title: "What is it?", body: "I-Parliament brings together and unites the youth across all social and economic backgrounds, it is truly a movement of the youth, by the youth and for the youth.\n\nI-Parliament provides an unique opportunity to learn first hand about how parliamentary democracy works, with special focus parliamentary strategy and political negotiations; making law; and holding government accountable to the people.\n\nI-Parliament bridges the gap between the Parliament of India and the Youth, the legislation discussed, resolution drafted and the bills amended are viewed and presented to Member(s) of Parliament for their consideration."),
		InfoItem(image: #imageLiteral(resourceName: "Logo"), title: "When is it?", body: "On the 30th of February"),
		InfoItem(image: #imageLiteral(resourceName: "Logo"), title: "How do I register?", body: "Press this button! (oh wait, you can't)"),
		InfoItem(image: #imageLiteral(resourceName: "Logo"), title: "Team", body: "Meeeeeee"),
		InfoItem(image: #imageLiteral(resourceName: "Logo"), title: "Gallery", body: "O/ hi there"),
	]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = items[0].title
		tabBarController?.view.backgroundColor = .white
		
		dataSource = self
		delegate = self
		
		if let controller = homeViewController(index: 0) {
			setViewControllers([controller], direction: .forward, animated: false, completion: nil)
		}
		
		let pageControl = UIPageControl.appearance()
		pageControl.backgroundColor = .black //TODO: Tweak the appearance more
    }
	
	func homeViewController(index: Int) -> HomeViewController? {
		guard let controller = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {return nil}
		controller.index = index
		controller.infoItem = items[index]
		return controller
	}

}

extension HomePageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let controller = viewController as? HomeViewController else {return nil}
		let newIndex = controller.index - 1
		guard newIndex > -1 else {
			return homeViewController(index: items.count - 1)
		}
		return homeViewController(index: newIndex)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let controller = viewController as? HomeViewController else {return nil}
		let newIndex = controller.index + 1
		guard newIndex < items.count else {
			return homeViewController(index: 0)
		}
		return homeViewController(index: newIndex)
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return items.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
}

extension HomePageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		guard let controller = pageViewController.viewControllers?.first as? HomeViewController,
			completed else {return}
		navigationItem.title = controller.infoItem.title
	}
}
