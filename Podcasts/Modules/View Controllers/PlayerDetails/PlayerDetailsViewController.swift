//
//  PlayerDetailsViewController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 07/04/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import ModernAVPlayer
import UIKit

final class PlayerDetailsViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: PlayerDetailsViewModel
    private lazy var playerView = PlayerStackView()

    // MARK: - View Controller's life cycle
    init(viewModel: PlayerDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Life cycle

extension PlayerDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        viewModel.playPauseEpisode()
    }

}

// MARK: - Setup

private extension PlayerDetailsViewController {

    func initialSetup() {
        view.backgroundColor = .white
        setupLayout()
        setupViews()
    }

    func setupViews() {
        playerView.delegate = self
        playerView.setTimeline(currentTime: viewModel.currentTime)
        playerView.setVolume(viewModel.currentVolume)

        playerView.titleLabel.text = viewModel.episode.title
        playerView.authorLabel.text = viewModel.episode.author

        guard let url = URL(string: viewModel.episode.imageUrl?.httpsUrlString ?? "") else { return }
        playerView.episodeImageView.setImage(from: url)
    }

    func setupLayout() {
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.bottom.right.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
        }
    }

}

// MARK: - PlayerStackViewDelegate

extension PlayerDetailsViewController: PlayerStackViewDelegate {

    func playerStackViewRewindAction() {
        viewModel.rewindEpisode()
    }

    func playerStackViewPlayPauseAction() {
        viewModel.playPauseEpisode()
    }

    func playerStackViewFastForwardAction() {
        viewModel.fastForwardEpisode()
    }

    func playerStackView(didCurrentVolumeChange currentVolume: Float) {
        viewModel.changeVolume(currentVolume)
    }

    func playerStackView(willChangeTimeline progress: Float) {
        viewModel.changeTimeline(progress)
    }

}

// MARK: - PlayerDetailsViewModelDelegate

extension PlayerDetailsViewController: PlayerDetailsViewModelDelegate {

    func playerDetailsViewModel(didCurrentVolumeChange currentVolume: Float) {
        playerView.setVolume(currentVolume)
    }

    func playerDetailsViewModel(didCurrentTimeChange currentTime: Double) {
        playerView.setTimeline(currentTime: currentTime)
    }

    func playerDetailsViewModel(didRemainigTimeChange remainingTime: Double) {
        playerView.setTimeline(leftTime: remainingTime)
    }

    func playerDetailsViewModel(didCurrentTimeLineChange currentFromEverything: Float) {
        playerView.setTimeLine(progress: currentFromEverything)
    }

    func playerDetailsViewModel(didCurrentStatechange isPaused: Bool) {
        playerView.setState(isPaused)
    }

}
