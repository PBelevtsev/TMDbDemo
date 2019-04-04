//
//  MovieCatalogVM.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

class MovieCatalogVM {
    
    var movies = [Movie]()
    var page: Int = 1
    var totalPages: Int = 0
    var inProgress: Bool = false
    var searchValue: String = ""
    
    func loadCatalog(_ page: Int = 1, search: String = "", _ completionHandler: @escaping (_ success: Bool) -> ()) {
        inProgress = true
        searchValue = search
        
        if RequestManager.shared.connected && (search.count == 0) {
            RequestManager.shared.popular(page: page) { (result, error) in
                if result != nil {
                    ResourcesManager.shared.storeMovies(result!.results)
                    self.fillMoviesList(result: result!)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
                self.inProgress = false
            }
        } else {
            let movies = ResourcesManager.shared.storedMovies(page: page, search: search)
            fillMoviesList(page: page, totalPages: (movies.count < ResourcesManager.moviesLimit) ? page : page + 1, movies: movies)
            completionHandler(true)
            self.inProgress = false
        }
        
    }
    
    func fillMoviesList(result: ListResult) {
        fillMoviesList(page: result.page, totalPages: result.totalPages, movies: result.results)
    }
    
    func fillMoviesList(page: Int, totalPages: Int, movies: [Movie]) {
        if page == 1 {
            self.movies.removeAll()
        }
        self.page = page
        self.totalPages = totalPages
        self.movies.append(contentsOf: movies)
    }
    
    func loadNextPage(_ completionHandler: @escaping (_ success: Bool) -> ()) {
        if !inProgress && page < totalPages {
            loadCatalog(page + 1, search: searchValue) { (success) in
                completionHandler(success)
            }
        } else {
            completionHandler(false)
        }
    }
    
}
