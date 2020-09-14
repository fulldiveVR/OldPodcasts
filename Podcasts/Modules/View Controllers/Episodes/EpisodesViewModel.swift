//
//  EpisodesViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 22/02/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class EpisodesViewModel {

    let podcast: Podcast
    let playerService: PlayerService

    private let networkingService = NetworkingService()
    private let podcastsService: PodcastsService

    private(set) var episodes = [Episode]()
    private(set) var dataSource: TableViewDataSource<Episode, EpisodeCell>?

    init(podcast: Podcast, podcastsService: PodcastsService, playerService: PlayerService) {
        self.podcast = podcast
        self.podcastsService = podcastsService
        self.playerService = playerService
    }
}

extension EpisodesViewModel {

    func fetchEpisodes(_ completion: @escaping () -> Void) {
        networkingService.fetchEpisodes(feedUrlSting: podcast.feedUrl) { [weak self] episodes in
            self?.episodesDidLoad(episodes)
            completion()
        }
    }

    func saveFavorite() {
        podcastsService.savePodcast(podcast)
    }

    func deleteFavorite() {
        podcastsService.deletePodcast(podcast)
    }

    func download(_ episode: Episode) {
        print("Downloading episode into UserDefaults")
        podcastsService.downloadEpisode(episode)
        networkingService.downloadEpisode(episode)
    }

    func episode(for indexPath: IndexPath) -> Episode {
        episodes[indexPath.row]
    }

    func checkIfPodcastHasFavorited() -> Bool {
        podcastsService.savedPodcasts.contains(where: { $0.feedUrl == podcast.feedUrl })
    }

    private func episodesDidLoad(_ episodes: [Episode]) {
        self.episodes = episodes
        dataSource = .make(for: episodes)
    }
}
