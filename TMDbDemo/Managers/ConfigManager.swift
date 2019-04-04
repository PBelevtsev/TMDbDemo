//
//  ConfigManager.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

class ConfigManager {
    
    static let shared = ConfigManager()
    
    public static let apiURL = "https://api.themoviedb.org/3/movie/"
    public static let apiKey = "a904799bfdda806b0d10e32010da4d84"
    public static let imageURL = "https://image.tmdb.org/t/p/w500"
    
}
