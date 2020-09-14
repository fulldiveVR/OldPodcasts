//
//  PodcastsSearchViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PodcastsSearchViewModel {

    let podcastsService: PodcastsService
    let playerService: PlayerService

    private let networkingService: NetworkingService
    private var timer: Timer?
    private(set) var dataSource: TableViewDataSource<Podcast, PodcastCell>?
    private(set) var podcasts = [Podcast]()

    init(
        podcastsService: PodcastsService,
        playerService: PlayerService,
        networkingService: NetworkingService = NetworkingService()
    ) {
        self.podcastsService = podcastsService
        self.playerService = playerService
        self.networkingService = networkingService
    }

}

extension PodcastsSearchViewModel {

    // TODO: Search with delay 0.3 sec
    func searchPodcasts(with query: String, completion: @escaping () -> Void) {
        deleteLoadedPodcasts()
        networkingService.fetchPodcasts(searchText: query) { [weak self] podcasts in
            self?.podcastsDidLoad(podcasts)
            completion()
        }
    }

    func topPodcasts(completion: @escaping () -> Void) {

    }

    func deleteLoadedPodcasts() {
        podcasts.removeAll()
        dataSource = .make(for: podcasts)
    }

    func podcast(for indexPath: IndexPath) -> Podcast {
        podcasts[indexPath.row]
    }

    private func podcastsDidLoad(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
        dataSource = .make(for: podcasts)
    }

}
