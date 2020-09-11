//
//  MPVolumeView+Extensions.swift
//  Podcasts
//
//  Created by Ruslan Mikailov on 11.09.2020.
//  Copyright © 2020 Eugene Karambirov. All rights reserved.
//

import MediaPlayer
import UIKit

extension MPVolumeView {

    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider?.value = volume
        }
    }

}
