//
//  DecodeType.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation


enum DecodeType {
    case listResult
    case movie
    case listVideos
    
    func decode(_ responseObject: Any?, _ completionHandler: @escaping (_ object: Any?, _ error: Error?) -> ()) {
        if let data = responseObject as? Data {
            do {
                let decoder = JSONDecoder()
                var result: Any?
                switch self {
                case .listResult:
                    result = try decoder.decode(ListResult.self, from: data)
                case .movie:
                    result = try decoder.decode(Movie.self, from: data)
                case .listVideos:
                    result = try decoder.decode(ListVideos.self, from: data)
                }
                completionHandler(result, nil);
            } catch let parsingError {
                completionHandler(nil, parsingError);
            }
        }
    }
    
}
