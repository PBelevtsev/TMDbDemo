//
//  ResourcesManager.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation

class ResourcesManager {
    
    static let shared = ResourcesManager()
    
    var genres = [Genre]()
    
    func genresList(from genreIds: [Int]?) -> [Genre]? {
        guard let ids = genreIds else { return nil }
        
        var result = [Genre]()
        for id in ids {
            if let genre = genres.first(where: { (item) -> Bool in
                return item.id == id
            }) {
                result.append(genre)
            } else {
                return nil
            }
        }
        
        return result
    }
    
    func storeGenres(_ genres: [Genre]) {
        for genre in genres {
            if !self.genres.contains(where: { (item) -> Bool in
                return genre.id == item.id
            }) {
                self.genres.append(genre)
            }
        }
    }
    
}
