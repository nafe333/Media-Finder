//
//  HistoryViewController.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 24/07/2023.
//

import UIKit
import AVFoundation
import AVKit

class HistoryVC: UIViewController {
    //MARK: - Properties
    var history: [mediaData] = []
    
    //MARK: - Outlets
    @IBOutlet weak var historyTableView: UITableView!
    
    
    
    //MARK: - LifeCyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        self.history = sqlLiteManager.shared.retrieveLastResult()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHistoryData()
    }
    //MARK: - Private Functions
    
    private func refreshHistoryData() {
        // Retrieve the history data and reload the table view
        self.history = sqlLiteManager.shared.retrieveLastResult()
        historyTableView.reloadData()
    }
    
    private func playPreview(for media: mediaData) {
        if let previewUrl = URL(string: media.previewUrl ?? "") {
            let player = AVPlayer(url: previewUrl)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
                if media.kind == "song"{
                    let imageView = UIImageView(image: UIImage(named: "musicc"))
                    imageView.contentMode = .scaleAspectFill
                    playerViewController.contentOverlayView?.addSubview(imageView)
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        imageView.leadingAnchor.constraint(equalTo: playerViewController.contentOverlayView!.leadingAnchor),
                        imageView.trailingAnchor.constraint(equalTo: playerViewController.contentOverlayView!.trailingAnchor),
                        imageView.topAnchor.constraint(equalTo: playerViewController.contentOverlayView!.topAnchor),
                        imageView.bottomAnchor.constraint(equalTo: playerViewController.contentOverlayView!.bottomAnchor)
                    ])
                }
            }
        }
    }
}

extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        
    }
}

extension HistoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        // Make sure indexPath.row is within bounds of the history array
        if indexPath.row < history.count {
            let mediaHistory = history[indexPath.row]
            let kind = mediaHistory.kind
            cell.mediaImageView.sd_setImage(with: URL(string: mediaHistory.artworkUrl100 ?? ""))
            if kind == "song" {
                cell.mediaTextLabel.text = mediaHistory.trackName
                cell.mediaInformationTextLabel.text = mediaHistory.artistName
            } else if kind == "feature-movie" {
                cell.mediaTextLabel.text = mediaHistory.trackName
                cell.mediaInformationTextLabel.text = mediaHistory.longDescription
            } else if kind == "tv-episode" {
                cell.mediaTextLabel.text = mediaHistory.artistName
                cell.mediaInformationTextLabel.text = mediaHistory.longDescription
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletionAction = UITableViewRowAction(style: .destructive, title: "Hide") { action , indexPath in
            self.history.remove(at: indexPath.row)
            self.historyTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deletionAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaHistory = history[indexPath.row]
        playPreview(for: mediaHistory)
    }
    
    
    
    
}
