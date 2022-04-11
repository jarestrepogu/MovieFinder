//
//  MovieManager.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//
import Foundation

struct MovieManager{
    
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
    
    func fetchMovie(isTrending: Bool, movieTitle: String?, apiKey: String, completionHandler: @escaping (Result<[Movie], Error>) -> Void) {
        
        var url = URL(string: "https://api.themoviedb.org")!
        
        if isTrending {
            url = trendingMovieURL(apiKey: apiKey)
        } else {
            if let movie = movieTitle {
                url = searchMovieURL(movieTitle: movie, apiKey: apiKey)
            }
        }
        
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
                    let movieData = try decoder.decode(MovieData.self, from: safeData)
                    completionHandler(.success(movieData.results))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
}
