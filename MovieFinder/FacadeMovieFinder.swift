//
//  FacadeMovieFinder.swift
//  MovieFinder
//
//  Created by Lina on 7/04/22.
//

import Foundation

class FacadeMovieFinder {
    
    private var movieManager: MovieManager
    private var posterManager: PosterManager
    private var providersManager: ProvidersManager
    private let apiKey: ApiKeys
    
    private var trendingMovies = [Movie]()
    private var foundMovies = [Movie]()
    
    //locale
    
    init(movieManager: MovieManager = MovieManager(), posterManager: PosterManager = PosterManager(), providersManager: ProvidersManager = ProvidersManager(), apiKeys: ApiKeys = ApiKeys()) {
        self.movieManager = movieManager
        self.posterManager = posterManager
        self.providersManager = providersManager
        self.apiKey = apiKeys
        
    }
    
    func getMovies(_ isTrending: Bool, _ movieTitle: String?) -> [Movie] {
        fetchMovies(isTrending: isTrending, movieTitle: movieTitle)
        if isTrending {
            return trendingMovies
        } else {
            return foundMovies
        }
    }
    
    func fetchMovies(isTrending: Bool, movieTitle: String?){
        movieManager.fetchMovie(isTrending: isTrending, movieTitle: movieTitle, apiKey: apiKey.tmdbKey) {
            result in
            
            if isTrending {
                do {
                    let movies = try result.get()
                } catch {
                    print(error)
                }
            } else {
                do {
                    let movies = try result.get()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getProviders(movieId: Int, countryCode: String) {
        providersManager.fetchProviders(movieId: String(movieId), apiKey: apiKey.tmdbKey, countryCode: Locale.current.regionCode ?? "US") {
            result in
            
        }
    }
}

// IOS Interview Questions
// Patrones de diseño (Creacionales, Comportamiento, Estructurales)
// Manejo memoria (ARC)
// Diferencias entre clases y structs
// Librerías
// Unit Tests
// Manejadores de dependencias en iOS "Cocoapods/Carthage/Swift Package Manager"

