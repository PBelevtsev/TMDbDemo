//
//  RequestManager.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
import AFNetworking

class RequestManager {
    
    static let shared = RequestManager(baseURL: ConfigManager.apiURL)
    
    let baseURL: String
    let manager = AFHTTPSessionManager()
    var connected = false
    var isInitialized = false
    
    init(baseURL: String) {
        self.baseURL = baseURL
    
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
    }
    
    func startReachability(_ completionHandler: @escaping () -> ()) {
        
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            self.connected = ((status == .reachableViaWWAN) || (status == .reachableViaWiFi))
            
            if !self.isInitialized {
                self.isInitialized = true
                completionHandler()
            }
        }

    }
    
    func popular(page: Int = 1, _ completionHandler: @escaping (_ result: ListResult?, _ error: Error?) -> ()) {
        let url = "\(baseURL)popular"
        let params = ["page": page, "api_key": ConfigManager.apiKey] as [String : Any]
        manager.get(url, parameters: params, progress: nil, success: { (operation, responseObject) in
  
            DecodeType.listResult.decode(responseObject, { (listResult, error) in
                completionHandler(listResult as? ListResult, error)
            })
        }) { (operation, error) in
            completionHandler(nil, error)
        }
    }
    
    func detail(movie: Movie, _ completionHandler: @escaping (_ result: Movie?, _ error: Error?) -> ()) {
        guard let movieId = movie.id else {
            completionHandler(nil, nil)
            return
        }
        
        let url = "\(baseURL)\(movieId)"
        let params = ["api_key": ConfigManager.apiKey] as [String : Any]
        manager.get(url, parameters: params, progress: nil, success: { (operation, responseObject) in
            
            DecodeType.movie.decode(responseObject, { (movie, error) in
                completionHandler(movie as? Movie, error)
            })
        }) { (operation, error) in
            completionHandler(nil, error)
        }
    }
    
    func videos(movie: Movie, _ completionHandler: @escaping (_ result: ListVideos?, _ error: Error?) -> ()) {
        guard let movieId = movie.id else {
            completionHandler(nil, nil)
            return
        }
        
        let url = "\(baseURL)\(movieId)/videos"
        let params = ["api_key": ConfigManager.apiKey] as [String : Any]
        manager.get(url, parameters: params, progress: nil, success: { (operation, responseObject) in
            
            DecodeType.listVideos.decode(responseObject, { (listVideos, error) in
                completionHandler(listVideos as? ListVideos, error)
            })
        }) { (operation, error) in
            completionHandler(nil, error)
        }
    }
    
}

