//
//  ProvidersViewModel.swift
//  MovieFinder
//
//  Created by Lina on 26/04/22.
//

import Foundation

final class ProvidersViewModel {
    enum FetchError {
        case emptyBuy
        case emptyFlatrate
        case emptyRent
        case error(Error)
    }
    
    private let facade = FacadeMovieFinder()
    var movieId = Int()
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
                case .success(let providers):
                    self.isLoading = false
                    if ((providers.buy?.isEmpty) != nil){ // <--------
                        self.errorHandler?(.emptyBuy)
                    }
                    if ((providers.flatrate?.isEmpty) != nil){ // <--------
                        self.errorHandler?(.emptyFlatrate)
                    }
                    if ((providers.rent?.isEmpty) != nil){ // <--------
                        self.errorHandler?(.emptyRent)
                    }
                    self.providers = providers
                case .failure(let error):
                    self.errorHandler?(.error(error))
                }
            }
        }
    }
}
