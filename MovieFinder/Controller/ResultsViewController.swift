//
//  ResultsViewController.swift
//  MovieFinder
//
//  Created by Lina on 2/04/22.
//

import UIKit
import Kingfisher

class ResultsViewController: UITableViewController {
    
    private var movieManager = MovieManager()
    private var posterManager = PosterManager()
    private let webHelper = WebHelper()
    private let apiKey = ApiKeys()
    
    private var foundMovies = [MovieModel]()
    private var searchQuery = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        movieManager.fetchMovie(url: self.webHelper.searchMovieURL(movieTitle: searchQuery, apiKey: self.apiKey.tmdbKey))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.rowHeight = 175
        
    }
    
    func setQuery(_ query: String) {
        searchQuery = query
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = foundMovies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MovieCell
        cell.movieTitle.text = movie.title
        cell.movieOverview.text = movie.overview
        cell.movieVotes.text = String(movie.votes)
        if let poster = movie.posterPath {
            let posterURL = URL(string: self.posterManager.fetchPosterURL(posterPath: poster))
            cell.posterImage.kf.setImage(with: posterURL)
        }
        
        return cell
    }
}

//MARK: - MovieManagerDelegate

extension ResultsViewController: MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        
        foundMovies = movie
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
