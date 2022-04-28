//
//  ProvidersViewModel.swift
//  MovieFinder
//
//  Created by Lina on 26/04/22.
//

import Foundation

final class ProvidersViewModel {
    enum FetchError {
        case error(Error)
    }
    
    private let facade = FacadeMovieFinder()
    var movieId = Int()
    var providersGroup: ProvidersData?
    var providers: ProviderGroup? {
        didSet {providersDidChange?()}
    }
    var isLoading: Bool = false {
        didSet { isLoadingHandler?(isLoading) }
    }
    
    var isLoadingHandler: ((Bool) -> Void)?
    var errorHandler: ((FetchError) -> Void)?
    var providersDidChange: (() -> Void)?
    
    func fetchProviders() {
        facade.fetchProviders(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let providersGroup):
                    self.isLoading = false
                    if let providers = providersGroup.results[Locale.current.regionCode ?? "US"] {
                        self.providers = providers
                    }
                case .failure(let error):
                    self.errorHandler?(.error(error))
                }
            }
        }
    }
}
