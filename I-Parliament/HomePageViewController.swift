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
		InfoItem(image: #imageLiteral(resourceName: "Image1"), title: "About I-Parliament", body: "I-Parliament brings together and unites youth across all social and economic backgrounds. It is truly a movement of the youth, by the youth and for the youth.\n\nI-Parliament provides a unique opportunity to experience first-hand how parliamentary democracy works, with special focus on parliamentary strategy and political negotiations; making laws; and holding the government accountable to the people.\n\nI-Parliament bridges the gap between the Parliament of India and the youth. The legislations discussed, resolutions drafted and the bills amended are viewed and presented to Member(s) of Parliament for their consideration."),
		InfoItem(image: #imageLiteral(resourceName: "Image2"), title: "About Democracy Club", body: "India is the world’s largest democracy. We believe that a continuous and concerted effort must be made amongst the youth in order to maintain the vibrancy that is characteristic of a mature and ideal democracy.\n\nThe I-Parliament team is introducing a series of clubs/societies in different schools across the country. Students will have the opportunity to come together and discuss matters that they deem fit within the framework of democratic and constitutional values.\n\nIn the future these Democracy Clubs will elect students to represent them at the I-Parliament.")
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
