//
//  Movie.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

class Movie: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIds: [Int]?
    var id: Int?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var genres: [Genre]?
    var videoKey: String?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres = "genres"
    }
    
    func backdropUrl() -> URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: ConfigManager.imageURL + path)
    }
    
}

//{
//    adult = 0;
//    "backdrop_path" = "/umC04Cozevu8nn3JTDJ1pc7PVTn.jpg";
//    "genre_ids" =     (
//        28,
//        53
//    );
//    id = 245891;
//    "original_language" = en;
//    "original_title" = "John Wick";
//    overview = "Ex-hitman John Wick comes out of retirement to track down the gangsters that took everything from him.";
//    popularity = "78.17";
//    "poster_path" = "/b9uYMMbm87IBFOq59pppvkkkgNg.jpg";
//    "release_date" = "2014-10-22";
//    title = "John Wick";
//    video = 0;
//    "vote_average" = "7.1";
//    "vote_count" = 9378;
//},
