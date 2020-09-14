//
//  PodcastsService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 14/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PodcastsService {

    // MARK: - Properties
    var savedPodcasts: [Podcast] {
        fetchSavedPodcasts()
    }

    var downloadedEpisodes: [Episode] {
        fetchDownloadedEpisodes()
    }
}

// MARK: - Methods
extension PodcastsService {

    func savePodcast(_ podcast: Podcast) {
        var podcasts = savedPodcasts
        podcasts.append(podcast)
        guard
            let data = try? NSKeyedArchiver.archivedData(withRootObject: podcasts, requiringSecureCoding: false)
        else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

    func deletePodcast(_ podcast: Podcast) {
        let podcasts = savedPodcasts
        let filteredPodcasts = podcasts.filter { $0.feedUrl != podcast.feedUrl }

        guard
            let data = try? NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
        else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

    func downloadEpisode(_ episode: Episode) {
        do {
            var episodes = downloadedEpisodes
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("Failed to encode episode:", encodeError)
        }
    }

    func deleteEpisode(_ episode: Episode) {
        let savedEpisodes = downloadedEpisodes
        let filteredEpisodes = savedEpisodes.filter { $0.streamUrl != episode.streamUrl }

        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeError {
            print("Failed to encode episode:", encodeError)
        }
    }
}

// MARK: - Private

extension PodcastsService {

    private func fetchSavedPodcasts() -> [Podcast] {
        guard
            let savedData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey),
            let savedPodcasts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Podcast]
        else { return [] }

        return savedPodcasts
    }

    private func fetchDownloadedEpisodes() -> [Episode] {
        guard
            let episodesData = UserDefaults.standard.value(forKey: UserDefaults.downloadedEpisodesKey) as? Data
        else { return [] }

        do {
            return try JSONDecoder().decode([Episode].self, from: episodesData)
        } catch let decodeError {
            print("Failed to decode:", decodeError)
        }

        return []
    }
}
