//
//  MovieModel.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//

import UIKit

// MARK: - MovieData
struct MovieData: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
}

// MARK: - Result
struct Movie: Decodable {
    let id: Int
    let originalTitle, overview: String
    let posterPath: String?
    let title: String
    let voteAverage: Double
}
