//
//  MoviePlayerViewController.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class MoviePlayerViewController: UIViewController {

    public static let reuseIdentifier = "MoviePlayerViewController"
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var buttonDone: UIButton!
    
    var videoKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let key = videoKey {
            playerView.delegate = self
            playerView.load(withVideoId: key)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidBecomeHidden), name: UIWindow.didBecomeHiddenNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func windowDidBecomeHidden(_ notification : NSNotification) {
        closePlayer()
    }
    
    @IBAction func buttonDonePressed(_ sender: UIButton) {
        closePlayer()
    }
    
    func closePlayer() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MoviePlayerViewController: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            closePlayer()
        }
    }
}
