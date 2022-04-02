//
//  PosterManager.swift
//  MovieFinder
//
//  Created by Lina on 30/03/22.
//

import Foundation

struct PosterManager {
       
    let posterURL = "https://image.tmdb.org/t/p/w300"
        
    func fetchPosterURL(posterPath: String) -> String{
        
        return "\(posterURL)\(posterPath)"
    }
}
