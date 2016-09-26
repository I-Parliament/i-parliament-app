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
		InfoItem(image: #imageLiteral(resourceName: "Image1"), title: "What is I-Parliament?", body: "I-Parliament brings together and unites the youth across all social and economic backgrounds, it is truly a movement of the youth, by the youth and for the youth.\n\nI-Parliament provides an unique opportunity to learn first hand about how parliamentary democracy works, with special focus parliamentary strategy and political negotiations; making law; and holding government accountable to the people.\n\nI-Parliament bridges the gap between the Parliament of India and the Youth, the legislation discussed, resolution drafted and the bills amended are viewed and presented to Member(s) of Parliament for their consideration."),
		InfoItem(image: #imageLiteral(resourceName: "Image2"), title: "What is Democracy Club?", body: "We at I-Parliament think that the process of democracy must engage all citizens of a country and begin early on in their lives so that they become responsible for their own governance, are able to make informed choices, and meaningfully participate in the democratic life of the country. It is for these reasons that some successful democracies have active civic learning and engagement programmes by which different sections of society are exposed to democratic processes in an effort to build a strong and vibrant democratic culture. India is the world’s largest democracy. We believe that a continuous and concerted effort must be made among the youth in order to maintain the vibrancy that is characteristic of a mature and ideal democracy. The I-parliament team is introducing a series of clubs/societies in different schools across the country in which students will have the opportunity to come together and discuss matters that they deem fit within the framework of democratic and constitutional values. In the future these Democracy Clubs will elect students to represent them at the I-Parliament.")
	]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dataSource = self
		delegate = self
		
		navigationItem.title = items[0].title
		tabBarController?.view.backgroundColor = .white
		
		if let controller = homeViewController(at: 0) {
			setViewControllers([controller], direction: .forward, animated: false, completion: nil)
		}
		
		let pageControl = UIPageControl.appearance()
		pageControl.backgroundColor = .white
		pageControl.currentPageIndicatorTintColor = UIApplication.shared.keyWindow?.tintColor
		pageControl.pageIndicatorTintColor = .lightGray
    }
	
	func homeViewController(at index: Int) -> HomeViewController? {
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
		guard newIndex > -1 else {return nil}
		return homeViewController(at: newIndex)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let controller = viewController as? HomeViewController else {return nil}
		let newIndex = controller.index + 1
		guard newIndex < items.count else {return nil}
		return homeViewController(at: newIndex)
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
