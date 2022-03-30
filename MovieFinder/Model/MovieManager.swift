//
//  MovieManager.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//
import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel)
    func didFailWithError (error: Error)
}

struct MovieManager{
    let movieURL = "https://api.themoviedb.org/3/search/movie?api_key=0b6427eb04f70a5789d6598caaef7c17&query="
    
    var delegate: MovieManagerDelegate?
    
    func fetchMovie(movieTitle: String){
        
        let urlString = "\(movieURL)&query=\(movieTitle)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        performRequest(with: urlString!)
        //print(urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create URL
                
        if let url = URL(string: urlString){
            //2. Create a URL session
            
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            
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
            
            //4. Start the task
            task.resume()
            
        }        
    }
    
    func parseJSON(_ movieData: Data) -> MovieModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            let title = decodedData.results[0].title
            let overview = decodedData.results[0].overview
            let popularity = decodedData.results[0].popularity
            let posterPath = decodedData.results[0].posterPath ?? nil
            
            let movie = MovieModel(title: title, overview: overview, popularity: popularity, posterPath: posterPath)
            return movie
                        
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }    
}
