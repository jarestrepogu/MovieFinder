//
//  NetworkManager.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//
import Foundation

struct NetworkManager{
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    let page: String = ""
    
    func searchMovieURL(movieTitle: String, apiKey: String) -> URL {
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
    
    func trendingMovieURL(apiKey: String) -> URL{
        var url = URLComponents()
        url.host = "api.themoviedb.org"
        url.scheme = "https"
        url.path = "/3/trending/movie/day"
        url.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return URL(string: url.string!)!
    }
    
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
    
    func request<T: Decodable>(url: URL?, expecting: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = url else {
            completionHandler(.failure(CustomError.invalidUrl))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(expecting, from: data)
                completionHandler(.success(result))
            }
            catch {
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
}


