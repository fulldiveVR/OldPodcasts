//
//  VolumeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 19/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

protocol VolumeControlStackViewDelegate: AnyObject {
    func volumeControlStackView(didCurrentVolumeChange currentVolume: Float)
}

final class VolumeControlStackView: UIStackView {

    weak var delegate: VolumeControlStackViewDelegate?

    // MARK: - Properties
    private lazy var currentVolumeSlider = UISlider()
    private lazy var mutedVolumeImageView = UIImageView()
    private lazy var maxVolumeImageView = UIImageView()

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupVolumeSlider()
        setupImageViews()
        setupLayout()
    }

}

// MARK: - Setup

private extension VolumeControlStackView {

    func setupLayout() {
        addArrangedSubview(mutedVolumeImageView)
        addArrangedSubview(currentVolumeSlider)
        addArrangedSubview(maxVolumeImageView)
    }

    func setupImageViews() {
        mutedVolumeImageView.image = UIImage(systemSymbol: .speakerFill)
        maxVolumeImageView.image = UIImage(systemSymbol: .speaker3Fill)
    }

    func setupVolumeSlider() {
        currentVolumeSlider.addTarget(self, action: #selector(changeVolume(_:)), for: .valueChanged)
    }

}

// MARK: - Public actions

extension VolumeControlStackView {

    func setVolume(_ value: Float, animated: Bool = true) {
        currentVolumeSlider.setValue(value, animated: animated)
    }

}

// MARK: - Private actions

private extension VolumeControlStackView {

    @objc
    func changeVolume(_ sender: UISlider) {
        delegate?.volumeControlStackView(didCurrentVolumeChange: sender.value)
    }

}
