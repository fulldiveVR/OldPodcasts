//
//  PlayerDetailsViewModel.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import Foundation

protocol PlayerDetailsViewModelDelegate: AnyObject {
    func playerDetailsViewModel(didCurrentVolumeChange currentVolume: Float)
    func playerDetailsViewModel(didCurrentTimeChange currentTime: Double)
    func playerDetailsViewModel(didRemainigTimeChange remainigTime: Double)
    func playerDetailsViewModel(didCurrentTimeLineChange currentFromEverything: Float)
    func playerDetailsViewModel(didCurrentStatechange isPaused: Bool)
}

final class PlayerDetailsViewModel {

    weak var delegate: PlayerDetailsViewModelDelegate?

    let episode: Episode
    private let playerService: PlayerService
    private var itemDuration: Double?

    init(episode: Episode, playerService: PlayerService) {
        self.episode = episode
        self.playerService = playerService
        self.playerService.delegate = self
    }

    var currentTime: Double {
        playerService.currentTime.isNaN ? 0 : playerService.currentTime
    }

    var isPaused: Bool {
        playerService.playerState == .paused
    }

    var currentVolume: Float {
        playerService.currentVolume
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

    func changeVolume(_ value: Float) {
        playerService.changeVolume(value)
    }

    func changeTimeline(_ progress: Float) {
        guard let itemDuration = self.itemDuration else { return }
        let position = Double(progress) * itemDuration
        playerService.seek(to: position)
    }

}

// MARK: - PlayerServiceDelegate

extension PlayerDetailsViewModel: PlayerServiceDelegate {

    func playerService(didCurrentVolumeChange currentVolume: Float) {
        delegate?.playerDetailsViewModel(didCurrentVolumeChange: currentVolume)
    }

    func playerService(didCurrentTimeChange currentTime: Double) {
        delegate?.playerDetailsViewModel(didCurrentTimeChange: currentTime)
        if let itemDuration = self.itemDuration {
            let remainingTime = itemDuration - currentTime
            delegate?.playerDetailsViewModel(didRemainigTimeChange: remainingTime)

            if playerService.playerState == .playing {
                let currentFromEverything = Float(currentTime / itemDuration)
                delegate?.playerDetailsViewModel(didCurrentTimeLineChange: currentFromEverything)
            }
        }
    }

    func playerService(didCurrentStateChange isPaused: Bool) {
        DispatchQueue.main.async {
            self.delegate?.playerDetailsViewModel(didCurrentStatechange: isPaused)
        }
    }

    func playerService(didItemDurationChange itemDuration: Double?) {
        self.itemDuration = itemDuration
    }

}
