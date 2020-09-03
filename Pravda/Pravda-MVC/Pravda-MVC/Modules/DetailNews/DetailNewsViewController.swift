//
//  DetailNewsViewController.swift
//  Pravda-MVC
//
//  Created by Дмитрий Матвеенко on 05.08.2020.
//  Copyright © 2020 GkFoxes. All rights reserved.
//

import Models
import PravdaUIKit

protocol DetailNewsViewControllerFactoryProtocol: UIViewController {
	func setItem(_ detailNews: DetailNewsItem)
}

final class DetailNewsViewController: UIViewController, SafariViewControllerDelegate {

	// MARK: Properties

	private var isNewsFavorite = false // temp, should create favoriteService in CoreDataKit

	// MARK: Views

	private var detailNewsView: DetailNewsViewProtocol {
		guard let detailNewsView = view as? DetailNewsViewProtocol else { fatalError() }
		return detailNewsView
	}

	// MARK: Life Cycle

	override func loadView() {
		self.view = DetailNewsView(viewController: self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.largeTitleDisplayMode = detailNewsView.getNavigationLargeTitleDisplayMode()
		navigationItem.rightBarButtonItem = detailNewsView.getNavigationFavoriteButtonItem(isNewsFavorite: isNewsFavorite)
	}
}

// MARK: Factory Interface

extension DetailNewsViewController: DetailNewsViewControllerFactoryProtocol {
	func setItem(_ detailNews: DetailNewsItem) {
		detailNewsView.setItem(detailNews)
	}
}

// MARK: View Controller Interface

extension DetailNewsViewController: DetailNewsViewControllerProtocol {
	@objc func tapOnNavigationFavoriteButtonItem(_ sender: UIBarButtonItem?) {
		isNewsFavorite.toggle()
		navigationItem.rightBarButtonItem?.image = detailNewsView.getFavoriteButtonImage(isNewsFavorite: isNewsFavorite)
	}

	func getFavoriteButtonTitle() -> String {
		detailNewsView.getFavoriteButtonTitle(isNewsFavorite: isNewsFavorite)
	}

	func getFavoriteButtonImage() -> UIImage {
		detailNewsView.getFavoriteButtonImage(isNewsFavorite: isNewsFavorite)
	}
}
