//
//  TimeControlStackView.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 18/03/2019.
//  Copyright © 2019 Eugene Karambirov. All rights reserved.
//

import SnapKit
import UIKit

protocol TimeControlStackViewDelegate: AnyObject {
    func timeControlStackView(willChangeTimeline progress: Float)
}

final class TimeControlStackView: UIStackView {

    weak var delegate: TimeControlStackViewDelegate?

    // MARK: - Properties
    private lazy var currentTimeSlider = UISlider()
    private lazy var currentTimeLabel = UILabel()
    private lazy var durationLabel = UILabel()
    private lazy var timeStackView = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])

    // TODO: - Configure init to set labels text and value for slider

}

// MARK: - Life cycle

extension TimeControlStackView {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupLabels()
        setupLayout()
        setupSlider()
    }

}

// MARK: - Setup

private extension TimeControlStackView {

    func setupLayout() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(currentTimeSlider)
        addArrangedSubview(timeStackView)
        currentTimeSlider.snp.makeConstraints { $0.height.equalTo(36) }
        timeStackView.snp.makeConstraints { $0.height.equalTo(22) }
    }

    func setupLabels() {
        currentTimeLabel.text = "00:00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .lightGray

        durationLabel.text = "--:--:--"
        durationLabel.textAlignment = .right
        durationLabel.font = .systemFont(ofSize: 12)
        durationLabel.textColor = .lightGray
    }

    func setupSlider() {
        currentTimeSlider.addTarget(self, action: #selector(timeSliderAction(_:)), for: .valueChanged)
    }

}

// MARK: - Actions

extension TimeControlStackView {

    func setTimeLine(currentTime: Double) {
        currentTimeLabel.text = currentTime.toDisplayString()
    }

    func setTimeLine(leftTime: Double) {
        durationLabel.text = "-" + leftTime.toDisplayString()
    }

    func setTimeLine(progress: Float) {
        currentTimeSlider.setValue(progress, animated: true)
    }

}

// MARK: - Private Actions

private extension TimeControlStackView {

    @objc
    func timeSliderAction(_ sender: UISlider) {
        delegate?.timeControlStackView(willChangeTimeline: sender.value)
    }

}
