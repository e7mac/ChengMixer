//
//  TrackPickerViewController.swift
//  ChengMixer
//
//  Created by Mayank Sanganeria on 9/20/19.
//  Copyright © 2019 Cheyank. All rights reserved.
//

import UIKit

protocol TrackPickerViewControllerDelegate {
    func loadURL(_ url: URL)
}

class TrackPickerViewController: UITableViewController {

    var tracks: [URL] = []
    var delegate: TrackPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick track"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tracks = seekTracks()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.loadURL(tracks[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = tracks[indexPath.row].lastPathComponent
        cell.textLabel?.font = UIFont(name: "Georgia", size: 16)
        return cell
    }

    func seekTracks() -> [URL] {
        return seekFilesAtResources(path:"Tracks", ext: "mp3")
    }

    func seekFilesAtResources(path: String, ext: String) -> [URL] {
        var itemList: [URL] = []
        let resourceURL = Bundle.main.resourceURL?.appendingPathComponent(path)
        do {
            let items = try FileManager.default.contentsOfDirectory(at: resourceURL!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for item in items {
                if (item.pathExtension == ext) {
                    itemList.append(item)
                }
            }
            itemList.sort { (a, b) -> Bool in
                return a.lastPathComponent < b.lastPathComponent
            }
        } catch {
            print("File load error: \(error) at path: \(path)")
        }
        return itemList
    }

}
