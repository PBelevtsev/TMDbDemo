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
    case genres
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
        
        if let movieGenres = ResourcesManager.shared.genresList(from: movie.genreIds),
            movieGenres.count > 0 {
            self.genres = movieGenres
            cells.insert(.genres, at: 1)
        } else {
            downloadGroup.enter()
            RequestManager.shared.detail(movie: movie) { (movie, error) in
                if let movieForGenres = movie,
                    let movieGenres = movieForGenres.genres,
                    movieGenres.count > 0 {
                    
                    self.genres = movieGenres
                    self.cells.insert(.genres, at: 1)
                    ResourcesManager.shared.storeGenres(movieGenres)
                    
                }
                downloadGroup.leave()
            }
        }

        if movie.videoKey == nil {
            movie.videoKey = ResourcesManager.shared.storedVideoKey(movie: movie)
        }
        if self.movie!.videoKey == nil {
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
                        if let movie = self.movie {
                            movie.videoKey = trailer.key
                            ResourcesManager.shared.storeMovies([movie])
                        }
                    }
                }
                downloadGroup.leave()
            }
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            completionHandler(true)
        }
        
    }
    
    func genresList() -> String {
        if let movieGenres = self.genres,
            movieGenres.count > 0 {
            let names = movieGenres.map { (genre) -> String in
                return genre.name
            }
            return names.joined(separator: ", ")
        } else {
            return ""
        }
    }
    
    func cellData(_ cell: MovieDetailCell) -> (identifier: String, data: [String : String]?) {
        
        switch cell {
        case .header:
            return (DetailHeaderTableViewCell.reuseIdentifier, nil)
        case .genres:
            return (DetailInfoTableViewCell.reuseIdentifier, ["title": LS("Genres"), "info": genresList()])
        case .date:
            return (DetailInfoTableViewCell.reuseIdentifier, ["title": LS("Date"), "info": movie!.releaseDate ?? ""])
        case .overview:
            return (DetailInfoTableViewCell.reuseIdentifier, ["title": LS("Overview"), "info": movie!.overview ?? ""])
        }
        
    }
}
