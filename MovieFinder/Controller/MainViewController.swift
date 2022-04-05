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
        showSpinner()
                
        movieManager.delegate = self
        
        isTrending = true
        
        title = "Trending movies"
                
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 175
        
        movieManager.fetchMovie(url: webHelper.trendingMovieURL(apiKey: apiKey.tmdbKey))
    }
    
    //MARK: - Back to Trending Button
    
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
                    self.showSpinner()
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
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTrending{
            return trendingMovies.count
        } else {
            return foundMovies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var movie: MovieModel
        
        if isTrending {
            movie = trendingMovies[indexPath.row]
        } else {
            movie = foundMovies[indexPath.row]
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
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        
        destinationVC.loadViewIfNeeded()
        
        var movie: [MovieModel]
        
        if isTrending {
            movie = trendingMovies
        } else {
            movie = foundMovies
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.movieTitle.text = movie[indexPath.row].title
            destinationVC.movieVotes.text = String(movie[indexPath.row].votes)
            destinationVC.movieOverview.text = movie[indexPath.row].overview
            
            if let poster = movie[indexPath.row].posterPath {
                let posterURL = URL(string: self.posterManager.fetchPosterURL(posterPath: poster))
                destinationVC.posterImage.kf.setImage(with: posterURL)
            }
            
        }
    }
    
    //MARK: - MovieManagerDelegate
    
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        
        if isTrending {
            trendingMovies = movie
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.title = "Trending movies"
                self.removeSpinner()
            }
        } else {
            foundMovies = movie
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.removeSpinner()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

