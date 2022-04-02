//
//  MovieManager.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//
import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel])
    func didFailWithError(error: Error)
}

struct MovieManager{
   
    var delegate: MovieManagerDelegate?
        
    func fetchMovie(url: URL){
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let movie = self.parseJSON(safeData){
                    self.delegate?.didUpdateMovie(self, movie: movie)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ movieData: Data) -> [MovieModel]?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            var movieResults: [MovieModel] = []
                        
            for i in 0...decodedData.results.count - 1 {
                let movieResult = MovieModel(title: decodedData.results[i].title, overview: decodedData.results[i].overview, votes: decodedData.results[i].voteAverage, posterPath: decodedData.results[i].posterPath ?? "")
                movieResults.append(movieResult)
            }
            
            return movieResults
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }    
}
