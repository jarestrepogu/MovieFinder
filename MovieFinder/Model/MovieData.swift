//
//  MovieModel.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//

import Foundation

// MARK: - MovieData
struct MovieData: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
}

// MARK: - Result
struct Movie: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
