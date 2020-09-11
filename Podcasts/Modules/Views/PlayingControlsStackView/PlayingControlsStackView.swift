//
//  PlayingControlsStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SFSafeSymbols
import UIKit

protocol PlayingControlsStackViewDelegate: AnyObject {
    func playingControlsStackViewRewindAction()
    func playingControlsStackViewPlayPauseAction()
    func playingControlsStackViewFastForwardAction()
}

final class PlayingControlsStackView: UIStackView {

    weak var delegate: PlayingControlsStackViewDelegate?

    var isPaused: Bool = false {
        didSet {
            playPauseButton.setImage(isPaused ? .play : .pause, for: .normal)
        }
    }

    // MARK: - Properties
    private lazy var rewindButton = UIButton(type: .system)
    private lazy var playPauseButton = UIButton(type: .system)
    private lazy var fastForwardButton = UIButton(type: .system)

}

// MARK: - Life cycle

extension PlayingControlsStackView {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupButtons()
        setupLayout()
    }

}

// MARK: - Setup

private extension PlayingControlsStackView {

    func setupLayout() {
        addArrangedSubview(rewindButton)
        addArrangedSubview(playPauseButton)
        addArrangedSubview(fastForwardButton)
        alignment = .center
        distribution = .fillEqually
    }

    func setupButtons() {
        rewindButton.setImage(.gobackward15, for: .normal)
        rewindButton.addTarget(self, action: #selector(rewindAction(_:)), for: .touchUpInside)
        playPauseButton.setImage(isPaused ? .play : .pause, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseAction(_:)), for: .touchUpInside)
        fastForwardButton.setImage(.goforward15, for: .normal)
        fastForwardButton.addTarget(self, action: #selector(fastForwardAction(_:)), for: .touchUpInside)
    }

}

// MARK: - Actions

private extension PlayingControlsStackView {

    @objc
    func rewindAction(_ sender: UIButton) {
        delegate?.playingControlsStackViewRewindAction()
    }

    @objc
    func playPauseAction(_ sender: UIButton) {
        delegate?.playingControlsStackViewPlayPauseAction()
    }

    @objc
    func fastForwardAction(_ sender: UIButton) {
        delegate?.playingControlsStackViewFastForwardAction()
    }

}
