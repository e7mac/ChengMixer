//
//  ViewController.swift
//  ChengMixer
//
//  Created by Mayank Sanganeria on 9/19/19.
//  Copyright © 2019 Cheyank. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    var needsLoading = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(self.pickPressed)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (needsLoading) {
            needsLoading = false
            loadAudio(name: "vipassana")
            loadAudio(name: "sleep")

        }
    }
    func loadAudio(name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TrackViewController") as? TrackViewController
        addChild(vc!)
        stackView.addArrangedSubview(vc!.view)
        vc?.didMove(toParent: self)
        vc?.load(name: name)
    }

    @objc func pickPressed() {
        loadAudio(name: "vipassana")
//        let vc = TrackPickerViewController()
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
    }
}

