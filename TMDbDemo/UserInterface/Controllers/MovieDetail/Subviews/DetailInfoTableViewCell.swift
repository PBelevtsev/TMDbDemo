//
//  DetailInfoTableViewCell.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class DetailInfoTableViewCell: DetailTableViewCell {

    public static let reuseIdentifier = "DetailInfoTableViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func update(with movie: Movie, data: [String: String]? = nil) {
        super.update(with: movie, data: data)
        
        if let dataInfo = data {
            labelTitle.text = dataInfo["title"]
            labelInfo.text = dataInfo["info"]
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
