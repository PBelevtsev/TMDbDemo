//
//  Genre.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit
import CoreData

class Genre: Codable {
    var id: Int
    var name: String
 
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func create(object: NSManagedObject) -> Genre {
        return Genre(id: (object.value(forKey: "id") as! Int), name: (object.value(forKey: "name") as! String))
    }
    
}
