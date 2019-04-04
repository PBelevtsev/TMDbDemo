//
//  MovieDetailVM.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

enum MovieDetailCell {
    case header
    case date
    case overview
}

class MovieDetailVM {
    
    var movie: Movie?
    var genres: [Genre]?
    
    var cells = [MovieDetailCell]()
    
    func update(with movie: Movie, _ completionHandler: @escaping (_ success: Bool) -> ()) {
        self.movie = movie
        self.genres = nil
        
        cells.removeAll()
        
        cells.append(.header)
        cells.append(.date)
        cells.append(.overview)
        
        let downloadGroup = DispatchGroup()
        
        downloadGroup.enter()
        RequestManager.shared.detail(movie: movie) { (movie, error) in
            if let movieForGenres = movie,
                movieForGenres.genres != nil {
                self.genres = movieForGenres.genres
            }
            downloadGroup.leave()
        }

        if self.movie?.videoKey == nil {
            print("load videoKey")
            downloadGroup.enter()
            RequestManager.shared.videos(movie: movie) { (listVideos, error) in
                if listVideos != nil,
                    let results = listVideos!.results {
                    if let trailer = results.first(where: { (video) -> Bool in
                        if let _ = video.key,
                            let type = video.type,
                            type == "Trailer" {
                            return true
                        } else {
                            return false
                        }
                    }) {
                        self.movie?.videoKey = trailer.key
                    }
                }
                downloadGroup.leave()
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completionHandler(true)
        }
        
    }
    
    func cellData(_ cell: MovieDetailCell) -> (identifier: String, data: [String : String]?) {
        
        switch cell {
        case .header:
            return (DetailHeaderTableViewCell.reuseIdentifier, nil)
        case .date:
            return (DetailInfoTableViewCell.reuseIdentifier, ["title": LS("Date"), "info": movie!.releaseDate ?? ""])
        case .overview:
            return (DetailInfoTableViewCell.reuseIdentifier, ["title": LS("Overview"), "info": movie!.overview ?? ""])
        }
        
    }
}
