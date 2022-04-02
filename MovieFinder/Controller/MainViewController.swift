//
//  MainViewController.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private var movieManager = MovieManager()
    private var posterManager = PosterManager()
    private let webHelper = WebHelper()
    private let apiKey = ApiKeys()
    
    private var trendingMovies = [MovieModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        movieManager.fetchMovie(url: webHelper.trendingURL(apiKey: apiKey.tmdbKey))
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.rowHeight = 175
                
    }
    //MARK: - Search Button Pressed
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Search movie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Search", style: .default) { (action) in
            
            if textField.text != ""{
                if let movie = textField.text{
                    self.movieManager.fetchMovie(url: self.webHelper.apiURL(movieTitle: movie, apiKey: self.apiKey.tmdbKey))
                    print("Searching...\(movie)")
                }               
            } else {
                print("Nothing added")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Search for a movie"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = trendingMovies[indexPath.row]
        
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

extension MainViewController: MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
                
        trendingMovies = movie
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
