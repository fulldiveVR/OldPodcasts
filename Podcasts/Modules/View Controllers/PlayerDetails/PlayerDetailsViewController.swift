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
        playerView.isPaused = viewModel.isPaused
        playerView.timeControlStackView.currentTimeLabel.text = viewModel.currentTime.toDisplayString()

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
        playerView.isPaused = viewModel.isPaused
    }

    func playerStackViewFastForwardAction() {
        viewModel.fastForwardEpisode()
    }

}
