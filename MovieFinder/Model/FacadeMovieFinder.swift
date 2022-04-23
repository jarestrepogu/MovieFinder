//
//  FacadeMovieFinder.swift
//  MovieFinder
//
//  Created by Lina on 7/04/22.
//

import Foundation


class FacadeMovieFinder {
    
    private var movieManager: MovieManager
    private var providersManager: ProvidersManager
    private let apiKey: ApiKeys
        
    init(movieManager: MovieManager = MovieManager(), providersManager: ProvidersManager = ProvidersManager(), apiKeys: ApiKeys = ApiKeys()) {
        self.movieManager = movieManager
        self.providersManager = providersManager
        self.apiKey = apiKeys
    }
    
    func fetchMovies(isTrending: Bool, movieTitle: String?, completionHandler: @escaping (Result<[Movie], Error>) -> Void) {
        movieManager.fetchMovie(isTrending: isTrending, movieTitle: movieTitle, apiKey: apiKey.tmdbKey, completionHandler: completionHandler)        
    }
    
    func fetchProviders(movieId: Int, completionHandler: @escaping (Result<ProviderGroup, Error>) -> Void) {
        providersManager.fetchProviders(movieId: String(movieId), apiKey: apiKey.tmdbKey, countryCode: Locale.current.regionCode ?? "US", completionHandler: completionHandler)
    }
}
