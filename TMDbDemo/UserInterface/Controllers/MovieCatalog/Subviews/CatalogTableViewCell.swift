//
//  CatalogTableViewCell.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit
import SDWebImage

class CatalogTableViewCell: UITableViewCell {

    public static let reuseIdentifier = "CatalogTableViewCell"
    
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var movie: Movie? {
        didSet {
            if movie != nil {
                if let backdropUrl = movie?.backdropUrl() {
                    imageViewBackdrop.sd_setImage(with: backdropUrl, completed: nil)
                }
                labelTitle.text = movie?.title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
