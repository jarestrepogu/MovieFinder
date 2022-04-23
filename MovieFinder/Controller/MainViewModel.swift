//
//  MainViewModel.swift
//  MovieFinder
//
//  Created by Lina on 23/04/22.
//

import UIKit
import Kingfisher

final class MainViewModel {
    enum FetchError {
        case emptyResponse
        case error(Error)
    }
    
    private let facade = FacadeMovieFinder()
    private var trendingMovies = [Movie]() {
        didSet { moviesDidChanged?() }
    }
    private var foundMovies = [Movie]() {
        didSet { moviesDidChanged?() }
    }
    private(set) var query: String?
    var isSearching: Bool {
        query != nil
    }
    var movies: [Movie] {
        isSearching ? foundMovies : trendingMovies
    }
    var isLoading: Bool = false {
        didSet { isLoadingHandler?(isLoading) }
    }
    var title: String {
        query?.isEmpty == false ? query! : Constants.trendingTitle
    }
    
    var isLoadingHandler: ((Bool) -> Void)?
    var errorHandler: ((FetchError) -> Void)?
    var moviesDidChanged: (() -> Void)?
    
    func fetchMovies() {
        isLoading = true
        facade.fetchMovies(isTrending: true, movieTitle: nil) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let resultMovies):
                    self.isLoading = false
                    self.trendingMovies = resultMovies
                case .failure(let error):
                    self.errorHandler?(.error(error))
                }
            }
        }
    }
    
    func search(movieQuery: String) {
        query = movieQuery
        isLoading = true
        facade.fetchMovies(isTrending: false, movieTitle: movieQuery) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let resultMovies):
                    self.isLoading = false
                    
                    if resultMovies.isEmpty {
                        self.errorHandler?(.emptyResponse)
                    } else {
                        self.foundMovies = resultMovies
                    }
                case .failure(let error):
                    self.errorHandler?(.error(error))
                }
            }
        }
    }
    
    func stopSeaching() {
        query = nil
        moviesDidChanged?()
    }
}
