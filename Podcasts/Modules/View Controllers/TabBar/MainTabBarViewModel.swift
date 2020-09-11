//
//  MainTabBarViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 26/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class MainTabBarViewModel {

    enum TabBarItem {
        case search
        case favorites
        case downloads
    }

    var items: [TabBarItem]

    init(items: [TabBarItem]) {
        self.items = items
    }
}

extension MainTabBarViewModel.TabBarItem {

    var viewController: UIViewController {
        switch self {
        case .search:
            let podcastsSearchViewModel = PodcastsSearchViewModel(
                podcastsService: ServiceLocator.podcastsService,
                playerService: ServiceLocator.playerService
            )
            let podcastsSearchViewController = PodcastsSearchViewController(viewModel: podcastsSearchViewModel)
            let controller = makeNavigationController(
                for: podcastsSearchViewController,
                title: "Search",
                image: UIImage(systemSymbol: .magnifyingglass)
            )
            return controller

        case .favorites:
            let favoritesViewModel = FavoritesViewModel(
                podcastsService: ServiceLocator.podcastsService,
                playerService: ServiceLocator.playerService
            )
            let favoritesViewController = FavoritesViewController(viewModel: favoritesViewModel)
            let controller = makeNavigationController(
                for: favoritesViewController,
                title: "Favorites",
                image: UIImage(systemSymbol: .playCircleFill)
            )
            return controller

        case .downloads:
            let downloadsViewModel = DownloadsViewModel()
            let downloadsViewController = DownloadsViewController(viewModel: downloadsViewModel)
            let controller = makeNavigationController(
                for: downloadsViewController,
                title: "Downloads",
                image: UIImage(systemSymbol: .icloudAndArrowDownFill)
            )
            return controller
        }
    }

    private func makeNavigationController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}
