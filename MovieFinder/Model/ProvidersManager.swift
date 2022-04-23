//
//  ProvidersManager.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit

struct ProvidersManager {
    
    func providersURL(movieId: String, apiKey: String) -> URL{
        var url = URLComponents()
        url.host = "api.themoviedb.org"
        url.scheme = "https"
        url.path = "/3/movie/\(movieId)/watch/providers"
        url.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return URL(string: url.string!)!
    }
    
    func fetchProviders(movieId: String, apiKey: String, countryCode: String, completionHandler: @escaping (Result<ProviderGroup, Error>) -> Void) {
        
        let url = providersURL(movieId: movieId, apiKey: apiKey)
        let session = URLSession(configuration: .default)        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let providersData = try decoder.decode(ProvidersData.self, from: safeData)
                    let group = providersData.results[countryCode] ?? .init(flatrate: nil, buy: nil, rent: nil)
                    completionHandler(.success(group))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }        
        task.resume()
    }
}
