//
//  PlayerService.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import AVFoundation
import Foundation
import MediaPlayer
import ModernAVPlayer

protocol PlayerServiceDelegate: AnyObject {
    func playerService(didCurrentVolumeChange currentVolume: Float)
    func playerService(didCurrentTimeChange currentTime: Double)
    func playerService(didCurrentStateChange isPaused: Bool)
    func playerService(didItemDurationChange itemDuration: Double?)
}

final class PlayerService {

    weak var delegate: PlayerServiceDelegate?

    private var observeValue: NSKeyValueObservation?

    init() {
        startObservingVolumeChanges()
        player.delegate = self
    }

    deinit {
        stopObservingVolumeChanges()
    }

    var playerState: ModernAVPlayer.State {
        player.state
    }

    var currentTime: Double {
        player.currentTime
    }

    var currentVolume: Float {
        AVAudioSession.sharedInstance().outputVolume
    }

    private var metadata: ModernAVPlayerMediaMetadata?
    private var media: ModernAVPlayerMedia?
    private var player = ModernAVPlayer(loggerDomains: [.state, .error])

    func load(episode: Episode) {
        // TODO: - Add playing from fileURL
        guard
            let episodeURL = URL(string: episode.streamUrl.httpsUrlString),
            let imageURL = URL(string: episode.imageUrl?.httpsUrlString ?? "")
        else { return }

        metadata = ModernAVPlayerMediaMetadata(title: episode.title, artist: episode.author, remoteImageUrl: imageURL)
        media = ModernAVPlayerMedia(url: episodeURL, type: .stream(isLive: true), metadata: metadata)

        guard let media = media else { return }
        player.load(media: media, autostart: true)
    }

    // MARK: - Playing commands
    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func stop() {
        player.stop()
    }

    func rewind() {
        player.seek(position: currentTime - 15)
    }

    func fastForward() {
        player.seek(position: currentTime + 15)
    }

    func seek(to position: Double) {
        player.seek(position: position)
    }

    func changeVolume(_ value: Float) {
        MPVolumeView.setVolume(value)
    }

}

// MAKR: - Setup

private extension PlayerService {

    func startObservingVolumeChanges() {
        let audioSession = AVAudioSession.sharedInstance()
        observeValue = audioSession.observe(\.outputVolume, options: [.initial, .new]) { _, value in
            if let newValue = value.newValue {
                self.delegate?.playerService(didCurrentVolumeChange: newValue)
            }
        }
    }

    func stopObservingVolumeChanges() {
        observeValue?.invalidate()
        observeValue = nil
    }

}

// MARK: - ModernAVPlayerDelegate

extension PlayerService: ModernAVPlayerDelegate {

    func modernAVPlayer(_ player: ModernAVPlayer, didCurrentTimeChange currentTime: Double) {
        delegate?.playerService(didCurrentTimeChange: currentTime)
    }

    func modernAVPlayer(_ player: ModernAVPlayer, didStateChange state: ModernAVPlayer.State) {
        delegate?.playerService(didCurrentStateChange: state == .paused)
    }

    func modernAVPlayer(_ player: ModernAVPlayer, didItemDurationChange itemDuration: Double?) {
        delegate?.playerService(didItemDurationChange: itemDuration)
    }

}
