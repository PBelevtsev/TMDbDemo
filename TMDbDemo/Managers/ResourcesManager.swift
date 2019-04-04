//
//  ResourcesManager.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ResourcesManager {
    
    static let shared = ResourcesManager()
    static let moviesLimit = 20

    var genres = [Genre]()

    // MARK: - Genres
    
    func loadGenres() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreDb")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                genres.append(Genre.create(object: data))
            }
        } catch {
            print("Failed")
        }
        
    }
    
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
                storeGenre(genre)
            }
        }
    }
    
    func storeGenre(_ genre: Genre) {
        self.genres.append(genre)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let genreEntity = NSEntityDescription.entity(forEntityName: "GenreDb", in: context)
        let newGenre = NSManagedObject(entity: genreEntity!, insertInto: context)
        newGenre.setValue(genre.id, forKey: "id")
        newGenre.setValue(genre.name, forKey: "name")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    // MARK: - Movies
    
    func storedMovies(page: Int, search: String) -> [Movie] {
        
        var movies = [Movie]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return movies }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDb")
        request.fetchLimit = ResourcesManager.moviesLimit;
        request.fetchOffset = ResourcesManager.moviesLimit * (page - 1);
        if search.count > 0 {
            request.predicate = NSPredicate(format: "(title CONTAINS[cd] %@)", search)
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for object in result {
                if let movieDb = object as? NSManagedObject {
                    movies.append(Movie.create(object: movieDb))
                }
            }
        } catch {
           
        }
        
        return movies
    }
    
    func storedMovie(id : Int?) -> NSManagedObject? {
        guard let movieId = id else { return nil }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDb")
        request.predicate = NSPredicate(format: "id = %i", movieId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            return result.first as? NSManagedObject
        } catch {
            return nil
        }
    }
    
    func storedVideoKey(movie: Movie) -> String? {
        let movieToCheck = storedMovie(id: movie.id)
        if movieToCheck != nil {
            return Movie.create(object: movieToCheck!).videoKey
        }
        return nil
    }
    
    func storeMovies(_ movies: [Movie]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        for movie in movies {
            var movieToSave = storedMovie(id: movie.id)
            if movieToSave == nil {
                let movieEntity = NSEntityDescription.entity(forEntityName: "MovieDb", in: context)
                movieToSave = NSManagedObject(entity: movieEntity!, insertInto: context)
            }
            if let backdropPath = movie.backdropPath { movieToSave!.setValue(backdropPath, forKey: "backdropPath") }
            if let genreIds = movie.genreIds { movieToSave!.setValue(genreIds, forKey: "genreIds") }
            if let id = movie.id { movieToSave!.setValue(id, forKey: "id") }
            if let overview = movie.overview { movieToSave!.setValue(overview, forKey: "overview") }
            if let releaseDate = movie.releaseDate { movieToSave!.setValue(releaseDate, forKey: "releaseDate") }
            if let title = movie.title { movieToSave!.setValue(title, forKey: "title") }
            if let videoKey = movie.videoKey { movieToSave!.setValue(videoKey, forKey: "videoKey") }
        }

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    
}
