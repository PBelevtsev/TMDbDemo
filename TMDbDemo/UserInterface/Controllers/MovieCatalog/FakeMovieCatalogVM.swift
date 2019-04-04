//
//  FakeMovieCatalogVM.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/4/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class FakeMovieCatalogVM: MovieCatalogVM {

    override func loadCatalog(_ page: Int = 1, search: String = "", _ completionHandler: @escaping (_ success: Bool) -> ()) {
        searchValue = search
        
        if let bundlePath = Bundle.main.path(forResource: "TestData", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath),
            let path = bundle.path(forResource: "movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                DecodeType.listResult.decode(data, { (listResult, error) in
                    if let result = listResult as? ListResult {
                        ResourcesManager.shared.storeMovies(result.results)
                        self.fillMoviesList(result: result)
                        completionHandler(true)
                    }
                })
            } catch {
                
            }
        }
    }
    
}
