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
    
    private var providersGroup: ProviderGroup?
    private var providerSections = 0
    private var providerCells = 0
        
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
    func configureProviders(_ providers: ProviderGroup) {
        var sections = 0
        var cells = 0
        if providers.buy != nil {
            sections += 1
            cells += providers.buy?.count ?? 0
        }
        if providers.flatrate != nil {
            sections += 1
            cells += providers.flatrate?.count ?? 0
        }
        if providers.rent != nil {
            sections += 1
            cells += providers.rent?.count ?? 0
        }
        providerSections = sections
        providerCells = cells
        print("Provider section is \(providerSections), and provider cells is \(providerCells)")
    }
    func storeProviders(_ providers: ProviderGroup) {
        providersGroup = providers
        print("Providers are stored")
    }
    func getProviders() -> ProviderGroup? {
        return providersGroup ?? nil
    }
    func getProviderSection() -> Int {
        return providerSections
    }
    func getProviderCells() -> Int {
        return providerCells
    }
}
