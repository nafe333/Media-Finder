//
//  MediaVC.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 25/05/2023.
//

import UIKit
import SDWebImage
import AVKit

class MediaVC: UIViewController {
    
    //MARK: - Properties
    var segmentControlValue: String = ""
    var resultsArr: [mediaData] = []
    var navigationBar : UINavigationBar!
    var baseURL: String = ""
    // for last search
    var lastSearchString: [String] = []
    var lastResults: [mediaData] = []
    var hasViewWillAppearBeenCalled = false
    var isDuplicate = false
    
    //MARK: - Outlets
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Segmented Controller Functions
    @IBAction func segmentedControllerValueChanger(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentControlValue = ""
        case 1:
            segmentControlValue = "&media=music"
        case 2:
            segmentControlValue = "&media=movie"
        case 3:
            segmentControlValue = "&media=tvShow"
        default:
            segmentControlValue = "&media=all"
        }
        handleSearchProcess()
    }
    
    //MARK: - LifeCycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        if !hasViewWillAppearBeenCalled {
            hasViewWillAppearBeenCalled = true
            if let lastSearchedURL = UserDefaults.standard.string(forKey: "LastSearchedURL") {
                handleLastSearchProcess(url: lastSearchedURL)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sqlLiteManager.shared.createLastResultTable()
        
        insertingLastSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setNavigationBar()
        let def = UserDefaults.standard
        def.set(true, forKey: UserDefaultKeys.isUserLoggedIn)
    }
    
    //MARK: - Functions
    
    @objc func buttonTapped(){
        goToProfileVC()
    }
    
    @objc func leftButtonTapped(){
        goToHistoryVC()
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        mediaTableView.delegate = self
        mediaTableView.dataSource = self
        mediaTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        searchBar.delegate = self
    }
    
    // Navigation Functions
    private func goToProfileVC() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let profileVC: ProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Views.profileVC) as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func goToHistoryVC() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: Storyboards.mainStoryboard, bundle: nil)
        let historyVC: HistoryVC = mainStoryboard.instantiateViewController(withIdentifier: Views.historyVC) as! HistoryVC
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    // Dealing with last search Functions
    private func insertingLastSearch(){
        guard let lastSearchResult = lastSearchString.last else {
            return
        }
        sqlLiteManager.shared.insertResult(lastSearch: lastSearchResult)
    }
    
    private func handleRetrieveLastResult(){
        let lastResult = lastResults.last
        do {
            let lastCell = mediaData(artistName: lastResult?.artistName ?? "None",
                                     artworkUrl100: lastResult?.artworkUrl100 ?? "",
                                     trackName: lastResult?.trackName ?? "",
                                     longDescription: lastResult?.longDescription ?? "",
                                     previewUrl: lastResult?.previewUrl ?? "",
                                     kind: lastResult?.kind ?? "")
            let lastCellData = try JSONEncoder().encode(lastCell)
            sqlLiteManager.shared.insertResult(lastCellRowData: lastCell, lastCellData: lastCellData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - playing music function
    
    private func playPreview(for media: mediaData) {
        if let previewUrl = URL(string: media.previewUrl ?? "") {
            let player = AVPlayer(url: previewUrl)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
                if media.kind == "song"{
                    let imageView = UIImageView(image: UIImage(named: "musicc"))
                    imageView.contentMode = .scaleAspectFit
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
    
    // Navigation Bar setting
    private func setNavigationBar(){
        // Assigning Navigation bar manually
        navigationItem.hidesBackButton = true
        self.navigationBar = UINavigationBar()
        self.view.addSubview(self.navigationBar)
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.navigationBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // For initializing Navigation Bar Buttons
        let navigationItem = UINavigationItem(title: "Media")
        self.navigationBar.setItems([navigationItem], animated: false)
        let rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(buttonTapped))
        let leftBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(leftButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

//MARK: - Table View Functions
extension MediaVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
}

extension MediaVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mediaTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let media = resultsArr[indexPath.row]
        
        let kind = media.kind
        
        cell.mediaImageView.sd_setImage(with: URL(string: media.artworkUrl100 ?? ""))
        if kind == "song" {
            cell.mediaTextLabel.text = media.trackName
            cell.mediaInformationTextLabel.text = media.artistName
        } else if kind == "feature-movie" {
            cell.mediaTextLabel.text = media.trackName
            cell.mediaInformationTextLabel.text = media.longDescription
        } else if kind == "tv-episode" {
            cell.mediaTextLabel.text = media.artistName
            cell.mediaInformationTextLabel.text = media.longDescription
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let media = resultsArr[indexPath.row]
        playPreview(for: media)
        
        if media != nil{
            handleRetrieveLastResult()
        }
        for lastResult in lastResults {
            if lastResult.artistName == media.artistName &&
                lastResult.artworkUrl100 == media.artworkUrl100 &&
                lastResult.trackName == media.trackName &&
                lastResult.longDescription == media.longDescription &&
                lastResult.previewUrl == media.previewUrl &&
                lastResult.kind == media.kind {
                isDuplicate = true
                break
            }
        }
        if !isDuplicate {
            lastResults.append(media)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletionAction = UITableViewRowAction(style: .destructive, title: "Hide") { action , indexPath in
            self.resultsArr.remove(at: indexPath.row)
            self.mediaTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deletionAction]
    }
}


//MARK: - Search Bar Functions
extension MediaVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        handleSearchProcess()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchProcess()
    }
    
    private func handleSearchProcess(){
        guard let searchText = searchBar.text else {
            return
        }
        let convertedSearchText = convertSearchBarText(searchText)
        let baseURL = "https://itunes.apple.com/search?term=\(convertedSearchText)\(segmentControlValue)"
        UserDefaults.standard.set(baseURL, forKey: "LastSearchedURL")
        
        
        APIManager.shared.getMediaData(baseURL: baseURL) { error, mediaArr in
            if let error = error {
                print("Error retrieving media data: \(error.localizedDescription)")
            } else if let mediaArr = mediaArr {
                self.resultsArr = mediaArr
                
                
                print("Retrieved media data: \(mediaArr)")
                
                self.mediaTableView.reloadData()
            }
        }
    }
    
    private func handleLastSearchProcess(url: String) {
        APIManager.shared.getMediaData(baseURL: url) { error, mediaArr in
            if let error = error {
                print("Error retrieving media data: \(error.localizedDescription)")
            } else if let mediaArr = mediaArr {
                self.resultsArr = mediaArr
                self.mediaTableView.reloadData()
            }
        }
    }
    
    // Space Refactoring
    private func convertSearchBarText(_ text: String) -> String {
        let convertedText = text.replacingOccurrences(of: " ", with: "+")
        return convertedText
    }
    
    
}


