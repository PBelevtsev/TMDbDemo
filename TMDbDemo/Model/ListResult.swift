//
//  ListResult.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class ListResult: Codable {
    var totalPages: Int
    var totalResults: Int
    var page: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page = "page"
        case results = "results"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        self.results = try container.decodeIfPresent([Movie].self, forKey: .results) ?? [Movie]()
    }
}
