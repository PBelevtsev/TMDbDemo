//
//  Movie.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
import CoreData

class Movie: Codable {
    var backdropPath: String?
    var genreIds: [Int]?
    var id: Int?
    var overview: String?
    var releaseDate: String?
    var title: String?
    var genres: [Genre]?
    var videoKey: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case overview = "overview"
        case releaseDate = "release_date"
        case title = "title"
        case genres = "genres"
    }
    
    func backdropUrl() -> URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: ConfigManager.imageURL + path)
    }
    
    static func create(object: NSManagedObject) -> Movie {
        let movie = Movie()
        movie.backdropPath = object.value(forKey: "backdropPath") as? String
        movie.genreIds = object.value(forKey: "genreIds") as? [Int]
        movie.id = object.value(forKey: "id") as? Int
        movie.overview = object.value(forKey: "overview") as? String
        movie.releaseDate = object.value(forKey: "releaseDate") as? String
        movie.title = object.value(forKey: "title") as? String
        movie.videoKey = object.value(forKey: "videoKey") as? String
        return movie
    }
    
}

