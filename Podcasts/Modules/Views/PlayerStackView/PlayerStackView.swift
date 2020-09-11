//
//  PlayerStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import UIKit

protocol PlayerStackViewDelegate: AnyObject {
    func playerStackViewRewindAction()
    func playerStackViewPlayPauseAction()
    func playerStackViewFastForwardAction()
    func playerStackViewChangeVolume(_ value: Float)
}

final class PlayerStackView: UIStackView {

    weak var delegate: PlayerStackViewDelegate?

    var isPaused: Bool = false {
        didSet {
            playingControlsStackView.isPaused = isPaused
        }
    }

    // MARK: - Properties
    lazy var episodeImageView = UIImageView()
    lazy var timeControlStackView = TimeControlStackView()
    lazy var titleLabel = UILabel()
    lazy var authorLabel = UILabel()
    private lazy var closeButton = UIButton(type: .system)
    private lazy var playingControlsStackView = PlayingControlsStackView()
    private lazy var volumeControlStackView = VolumeControlStackView()

    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupVolumeControlStackView()
        setupPlayingControlsStackView()
        setupEpisodeImageView()
        setupLabels()
        setupLayout()
    }

    func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }

    func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }

    func setVolume(_ value: Float) {
        volumeControlStackView.setVolume(value, animated: true)
    }

}

// MARK: - Setup

private extension PlayerStackView {

    func setupVolumeControlStackView() {
        volumeControlStackView.delegate = self
    }

    func setupPlayingControlsStackView() {
        playingControlsStackView.delegate = self
    }

    func setupLayout() {
        axis = .vertical
        spacing = 5
        let arrangedSubviews = [closeButton, episodeImageView, timeControlStackView, titleLabel, authorLabel, playingControlsStackView, volumeControlStackView]
        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }

    func setupEpisodeImageView() {
        episodeImageView.image = UIImage()
        episodeImageView.layer.cornerRadius = 5
        episodeImageView.clipsToBounds = true
        episodeImageView.snp.makeConstraints { $0.width.equalTo(episodeImageView.snp.height).multipliedBy(1 / 1) }
    }

    func setupLabels() {
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.snp.makeConstraints { $0.height.greaterThanOrEqualTo(20) }

        authorLabel.textAlignment = .center
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = AppConfig.tintColor
        authorLabel.snp.makeConstraints { $0.height.equalTo(20) }
    }

}

// MARK: - PlayingControlsStackViewDelegate

extension PlayerStackView: PlayingControlsStackViewDelegate {

    func playingControlsStackViewRewindAction() {
        delegate?.playerStackViewRewindAction()
    }

    func playingControlsStackViewPlayPauseAction() {
        delegate?.playerStackViewPlayPauseAction()
    }

    func playingControlsStackViewFastForwardAction() {
        delegate?.playerStackViewFastForwardAction()
    }

}

// MARK: - VolumeControlStackViewDelegate

extension PlayerStackView: VolumeControlStackViewDelegate {

    func volumeControlStackViewChangeVolume(_ value: Float) {
        delegate?.playerStackViewChangeVolume(value)
    }

}
