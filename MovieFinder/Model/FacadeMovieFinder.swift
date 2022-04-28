//
//  FacadeMovieFinder.swift
//  MovieFinder
//
//  Created by Lina on 7/04/22.
//

import Foundation


class FacadeMovieFinder {
    
    private var networkManager: NetworkManager
    private let apiKey: ApiKeys
    
    init(networkManager: NetworkManager = NetworkManager(), apiKeys: ApiKeys = ApiKeys()) {
        self.networkManager = networkManager
        self.apiKey = apiKeys
    }
    
    func fetchMovies(isTrending: Bool, movieTitle: String?, completionHandler: @escaping (Result<MovieData, Error>) -> Void) {
        var url = URL(string: "https://api.themoviedb.org")!
        
        if isTrending {
            url = networkManager.trendingMovieURL(apiKey: apiKey.tmdbKey)
        } else {
            if let movie = movieTitle {
                url = networkManager.searchMovieURL(movieTitle: movie, apiKey: apiKey.tmdbKey)
            }
        }        
        networkManager.request(url: url, expecting: MovieData.self, completionHandler: completionHandler)
    }
    
    func fetchProviders(movieId: Int, completionHandler: @escaping (Result<ProvidersData, Error>) -> Void) {
        let url = networkManager.providersURL(movieId: String(movieId), apiKey: apiKey.tmdbKey)
        networkManager.request(url: url, expecting: ProvidersData.self, completionHandler: completionHandler)
//        providersManager.fetchProviders(movieId: String(movieId), apiKey: apiKey.tmdbKey, countryCode: Locale.current.regionCode ?? "US", completionHandler: completionHandler)
    }
}
