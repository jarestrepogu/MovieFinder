//
//  WebHelper.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import Foundation

struct WebHelper {
    
    var page: String = "1"
        
    func apiURL(movieTitle: String, apiKey: String) -> URL {
        var url = URLComponents()
        url.host = "api.themoviedb.org"
        url.scheme = "https"
        url.path = "/3/search/movie"
        url.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: movieTitle),
            URLQueryItem(name: "page", value: page)
        ]
        return URL(string: url.string!)!
    }
    
    func trendingURL(apiKey: String) -> URL{var url = URLComponents()
        // https://api.themoviedb.org/3/trending/movie/day?api_key=0b6427eb04f70a5789d6598caaef7c17
        url.host = "api.themoviedb.org"
        url.scheme = "https"
        url.path = "/3/trending/movie/day"
        url.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return URL(string: url.string!)!        
    }
}
