//
//  TrackTableViewCell.swift
//  ChengMixer
//
//  Created by Mayank Sanganeria on 10/2/19.
//  Copyright © 2019 Cheyank. All rights reserved.
//

import UIKit
import AVFoundation

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var timelineSlider: UISlider!
    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
