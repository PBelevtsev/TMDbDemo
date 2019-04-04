//
//  TMDbDemoTests.swift
//  TMDbDemoTests
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import XCTest
@testable import TMDbDemo

class TMDbDemoTests: XCTestCase {
    var movieCatalogVC : MovieCatalogViewController!
    
    override func setUp() {
        ConfigManager.shared.testMode = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MovieCatalogViewController = storyboard.instantiateViewController(withIdentifier: "MovieCatalogViewController") as! MovieCatalogViewController
        let _ = vc.view
        movieCatalogVC = vc
    }

    override func tearDown() {
        movieCatalogVC = nil
    }

    func testMoviesList() {

        movieCatalogVC.reloadData()
        XCTAssertEqual(movieCatalogVC.model.movies.count, 15, "Check Movies list count")
        
        let firstCell = movieCatalogVC.tableView(movieCatalogVC.tableViewCatalog, cellForRowAt: IndexPath.init(row: 0, section: 0)) as! CatalogTableViewCell
        XCTAssert(firstCell.labelTitle.text == "Bumblebee", "First Movie should be 'Bumblebee'")
        
    }

}
