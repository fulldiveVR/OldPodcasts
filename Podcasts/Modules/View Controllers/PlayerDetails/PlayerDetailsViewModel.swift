//
//  PlayerDetailsViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

final class PlayerDetailsViewModel {

    let episode: Episode
    private let playerService: PlayerService

    init(episode: Episode, playerService: PlayerService) {
        self.episode = episode
        self.playerService = playerService
    }

    var currentTime: Double {
        playerService.currentTime.isNaN ? 0 : playerService.currentTime
    }

    var isPaused: Bool {
        playerService.playerState == .paused
    }

    func playPauseEpisode() {
        switch playerService.playerState {
        case .initialization, .failed:
            playerService.load(episode: episode)
            playerService.play()

        case .playing:
            playerService.pause()

        case .paused, .stopped, .loaded:
            playerService.play()

        case .buffering, .loading, .waitingForNetwork:
            print(">>> \(#function) \(playerService.playerState)")
        }
    }

    func rewindEpisode() {
        playerService.rewind()
    }

    func fastForwardEpisode() {
        playerService.fastForward()
    }

}
