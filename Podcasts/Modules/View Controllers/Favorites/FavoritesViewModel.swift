//
//  FavoritesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class FavoritesViewModel {

    let podcastsService: PodcastsService
    let playerService: PlayerService

    private(set) lazy var podcasts = podcastsService.savedPodcasts
    private(set) var dataSource: CollectionViewDataSource<Podcast, FavoritePodcastCell>?

    init(podcastsService: PodcastsService, playerService: PlayerService) {
        self.podcastsService = podcastsService
        self.playerService = playerService
    }
}

// MARK: - Methods
extension FavoritesViewModel {

    func fetchFavorites(_ completion: @escaping () -> Void) {
        podcastsDidLoad(podcasts)
        completion()
    }

    func podcast(for indexPath: IndexPath) -> Podcast {
        podcasts[indexPath.item]
    }

    func deletePodcast(for indexPath: IndexPath) {
        podcasts.remove(at: indexPath.item)
        let selectedPodcast = podcast(for: indexPath)
        podcastsService.deletePodcast(selectedPodcast)
        dataSource = .make(for: podcasts)
    }

    private func podcastsDidLoad(_ podcasts: [Podcast]) {
        dataSource = .make(for: podcasts)
    }
}
