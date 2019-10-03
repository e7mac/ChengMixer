//
//  TrackViewController.swift
//  ChengMixer
//
//  Created by Mayank Sanganeria on 9/20/19.
//  Copyright © 2019 Cheyank. All rights reserved.
//

import UIKit
import AVFoundation

class TrackViewController: UIViewController, TrackPickerViewControllerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timelineSlider: UISlider!
    var audioPlayer: AVAudioPlayer?
    var avPlayer: AVPlayer?

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        pickButton.addTarget(self, action: #selector(self.pickPressed), for: UIControl.Event.touchUpInside)

        playButton.addTarget(self, action: #selector(self.playPressed), for: UIControl.Event.touchUpInside)

        loopButton.addTarget(self, action: #selector(self.loopPressed), for: UIControl.Event.touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }


    func startTimer() {
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateView), userInfo: nil, repeats: true)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func updateView() {
        if let audioPlayer = audioPlayer {
            currentPositionLabel.text = timeIntervalFormatted(audioPlayer.currentTime)
            timelineSlider.value = Float(audioPlayer.currentTime / audioPlayer.duration)
        }
        if let currentItem = avPlayer?.currentItem {
            currentPositionLabel.text = timeIntervalFormatted(CMTimeGetSeconds(currentItem.currentTime()))
            timelineSlider.value = Float(CMTimeGetSeconds(currentItem.currentTime()) / CMTimeGetSeconds(currentItem.asset.duration))
        }
    }

    @objc func pickPressed() {
        let vc = TrackPickerViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func playPressed() {
        if let audioPlayer = audioPlayer {
            if (audioPlayer.isPlaying) {
                audioPlayer.pause()
                stopTimer()
            } else {
                audioPlayer.play()
                startTimer()
            }
        }
        if let avPlayer = avPlayer {
            if (avPlayer.rate == 1) {
                avPlayer.pause()
                stopTimer()
            } else {
                avPlayer.play()
                stopTimer()
            }
        }
    }

    @objc func loopPressed() {
        if let audioPlayer = audioPlayer {
            if (audioPlayer.numberOfLoops == 0) {
                audioPlayer.numberOfLoops = -1
                loopButton.alpha = 1
            } else {
                audioPlayer.numberOfLoops = 0
                loopButton.alpha = 0.5
            }
        }
    }

    @IBAction func timelineSliderChanged(_ sender: UISlider) {
        stopTimer()
        if let audioPlayer = audioPlayer {
            currentPositionLabel.text = timeIntervalFormatted( audioPlayer.duration * Double(sender.value))
        }
        if let currentItem = avPlayer?.currentItem {
            currentPositionLabel.text = timeIntervalFormatted( CMTimeGetSeconds(currentItem.asset.duration) * Double(sender.value))
        }
    }

    @IBAction func timelineSliderTouchUp(_ sender: UISlider) {
        startTimer()
        if let audioPlayer = audioPlayer {
            audioPlayer.currentTime = audioPlayer.duration * Double(sender.value)
        }
//        if let currentItem = avPlayer?.currentItem {
//        }
    }

    func loadURL(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
//        avPlayer = try AVPlayer(url: url)
        avPlayer?.play()
        audioPlayer?.play()
        trackNameLabel.text = url.lastPathComponent
        if let audioPlayer = audioPlayer {
            durationLabel.text = timeIntervalFormatted(audioPlayer.duration)
        }
        if let currentItem = avPlayer?.currentItem {
            durationLabel.text = timeIntervalFormatted(CMTimeGetSeconds(currentItem.asset.duration))
        }
        audioPlayer?.numberOfLoops = -1
        loopButton.alpha = 1
    }

    public func load(name: String) {
        let sound = Bundle.main.path(forResource: "Tracks/" + name, ofType: "mp3")
        let url = URL(fileURLWithPath: sound!)
        loadURL(url)
    }

    @IBAction func changeVolume(_ sender: UISlider) {
        if let audioPlayer = audioPlayer {
            audioPlayer.volume = sender.value
        }
        if let avPlayer = avPlayer {
            avPlayer.volume = sender.value
        }
    }

    func timeIntervalFormatted(_ time: TimeInterval) -> String {
        let interval = Int(time)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}
