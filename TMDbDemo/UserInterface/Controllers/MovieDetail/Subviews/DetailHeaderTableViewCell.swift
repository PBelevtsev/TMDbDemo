//
//  DetailHeaderTableViewCell.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: DetailTableViewCell {

    public static let reuseIdentifier = "DetailHeaderTableViewCell"
    
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonWatchTrailer: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonWatchTrailer.setTitle(LS("Watch Trailer"), for: .normal)
    }
    
    override func update(with movie: Movie, data: [String: String]? = nil) {
        super.update(with: movie, data: data)
        
        if let backdropUrl = movie.backdropUrl() {
            imageViewBackdrop.sd_setImage(with: backdropUrl, completed: nil)
        }
        labelTitle.text = movie.title
        buttonWatchTrailer.isEnabled = (movie.videoKey != nil)
        buttonWatchTrailer.alpha = buttonWatchTrailer.isEnabled ? 1.0 : 0.5
    }

    @IBAction func buttonWatchTrailerPressed(_ sender: UIButton) {
    
        if let videoKey = self.movie?.videoKey {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                let playerController = MoviePlayerViewController(nibName: MoviePlayerViewController.reuseIdentifier, bundle: nil) 
                playerController.videoKey = videoKey
                playerController.modalTransitionStyle = .crossDissolve
                playerController.modalPresentationStyle = .overCurrentContext
                topController.present(playerController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
