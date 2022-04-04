//
//  MainViewController.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import UIKit
import Kingfisher

class MainViewController: UITableViewController, MovieManagerDelegate{
    
    @IBOutlet weak var backbutton: UIBarButtonItem!
    @IBOutlet weak var searchMovieBar: UISearchBar!
    
    private var movieManager = MovieManager()
    private var posterManager = PosterManager()
    private let webHelper = WebHelper()
    private let apiKey = ApiKeys()
    
    private var trendingMovies = [MovieModel]()
    private var foundMovies = [MovieModel]()
    private var cachedMovies = [MovieModel]()
    private var isTrending = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        
        isTrending = true
        
        title = "Trending movies"
        movieManager.fetchMovie(url: webHelper.trendingMovieURL(apiKey: apiKey.tmdbKey))
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 175
    }
    
    //MARK: - Trending Button
    
    func showBackButton (){
        if navigationItem.leftBarButtonItem == nil{
            self.navigationItem.leftBarButtonItem = createBackButton()
        } else {
            self.navigationItem.setLeftBarButton(nil, animated:     true)
        }
    }
    
    @objc func trendingButtonPressed(_ sender: UIButton) {
        isTrending = true
        trendingMovies = cachedMovies
        showBackButton()
        title = "Trending movies"
        tableView.reloadData()
        
    }
    
    func createBackButton() -> UIBarButtonItem{
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left"), style: .plain, target: self, action: #selector(trendingButtonPressed(_ :)))
        leftButton.tintColor = UIColor.white
        return leftButton
    }
    
    //MARK: - Search Button Pressed
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Search for a movie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Search", style: .default) { (action) in
            
            if textField.text != ""{
                if let movie = textField.text{
                    self.cachedMovies = self.trendingMovies
                    self.isTrending = false
                    self.movieManager.fetchMovie(url: self.webHelper.searchMovieURL(movieTitle: movie, apiKey: self.apiKey.tmdbKey))
                    self.title = movie
                    
                    self.navigationItem.leftBarButtonItem = self.createBackButton()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTrending{
            return trendingMovies.count
        } else {
            return foundMovies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var movie: MovieModel
        
        if !isTrending {
            movie = foundMovies[indexPath.row]
        } else {
            movie = trendingMovies[indexPath.row]
        }
        
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
    //MARK: - MovieManagerDelegate
    
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        
        if !isTrending {
            foundMovies = movie
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            trendingMovies = movie
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.title = "Trending movies"
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
