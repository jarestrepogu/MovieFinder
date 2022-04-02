//
//  MainViewController.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import UIKit
import Kingfisher

class MainViewController: UITableViewController{
    
    private var movieManager = MovieManager()
    private var posterManager = PosterManager()
    private let webHelper = WebHelper()
    private let apiKey = ApiKeys()
    
    private var trendingMovies = [MovieModel]()
    private var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        movieManager.fetchMovie(url: webHelper.trendingMovieURL(apiKey: apiKey.tmdbKey))
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.rowHeight = 175
        
    }
    //MARK: - Search Button Pressed
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Search for a movie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Search", style: .default) { (action) in
            
            if textField.text != ""{
                if let movie = textField.text{
                    self.searchQuery = movie
                    self.performSegue(withIdentifier: "goToResult", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult"{
            let  destinationVC = segue.destination as! ResultsViewController
            destinationVC.setQuery(searchQuery)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
