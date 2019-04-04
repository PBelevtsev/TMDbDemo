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
    
    func loadCatalog(_ page: Int = 1, _ completionHandler: @escaping (_ success: Bool) -> ()) {
        inProgress = true
        RequestManager.shared.popular(page: page) { (result, error) in
            if result != nil {
                self.fillMoviesList(result: result!)
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            self.inProgress = false
        }
        
    }
    
    func fillMoviesList(result: ListResult) {
        if result.page == 1 {
            self.movies.removeAll()
        }
        page = result.page
        totalPages = result.totalPages
        self.movies.append(contentsOf: result.results)
    }
    
    func loadNextPage(_ completionHandler: @escaping (_ success: Bool) -> ()) {
        if !inProgress && page < totalPages {
            loadCatalog(page + 1) { (success) in
                completionHandler(success)
            }
        } else {
            completionHandler(false)
        }
    }
    
}
