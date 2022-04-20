//
//  MainViewController.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import UIKit
import Kingfisher

class MainViewController: UITableViewController {
    
    @IBOutlet weak var backbutton: UIBarButtonItem!
    @IBOutlet weak var searchMovieBar: UISearchBar!
    
    private let facade = FacadeMovieFinder()
    
    private var trendingMovies = [Movie]()
    private var foundMovies = [Movie]()
    private var cachedMovies = [Movie]()
    private var isTrending = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner()
        
        isTrending = true
        
        title = "Trending movies"
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 175
        
        facade.fetchMovies(isTrending: isTrending, movieTitle: nil, completionHandler: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let resultMovies):
                    self.trendingMovies = resultMovies
                    self.tableView.reloadData()
                    self.removeSpinner()                    
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
    //MARK: - Back to Trending Button
    func showBackButton (){
        if navigationItem.leftBarButtonItem == nil {
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
    
    func createBackButton() -> UIBarButtonItem {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left"), style: .plain, target: self, action: #selector(trendingButtonPressed(_ :)))
        leftButton.tintColor = UIColor.white
        return leftButton
    }
    
    //MARK: - Search Button Pressed
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Search for a movie", message: "", preferredStyle: .alert)      
        let action = UIAlertAction(title: "Search", style: .default) { (action) in
            
            if textField.text != "" {
                if let movie = textField.text {
                    self.cachedMovies = self.trendingMovies
                    self.isTrending = false
                    self.showSpinner()
                    self.facade.fetchMovies(isTrending: self.isTrending, movieTitle: movie, completionHandler: { [weak self] result in
                        
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            switch result {
                            case .success(let resultMovies):
                                if !resultMovies.isEmpty {
                                    self.foundMovies = resultMovies
                                    self.title = movie
                                    self.tableView.reloadData()
                                    self.removeSpinner()
                                    self.showBackButton()
                                } else {
                                    let nothingAlert = UIAlertController(title: "Nothing found", message: "", preferredStyle: .alert)
                                    self.present(nothingAlert, animated: true, completion: nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                        self.dismiss(animated: true, completion: nil)
                                        self.isTrending = true
                                        self.title = "Trending movies"
                                        self.tableView.reloadData()
                                        self.removeSpinner()
                                    }
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    })
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
        if isTrending {
            return trendingMovies.count
        } else {
            return foundMovies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var movie: Movie
        
        if isTrending {
            movie = trendingMovies[indexPath.row]
        } else {
            movie = foundMovies[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MovieCell
        cell.movieTitle.text = movie.title
        cell.movieOverview.text = movie.overview
        cell.movieVotes.text = String(movie.voteAverage)
        if let poster = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            cell.posterImage.kf.setImage(with: posterURL)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(identifier: "details") as! DetailsViewController
        
        var movies: [Movie]
        if isTrending {
            movies = trendingMovies
        } else {
            movies = foundMovies
        }
        destinationVC.setMovie(movies[indexPath.row])
        destinationVC.modalPresentationStyle = .popover
        present(destinationVC, animated: true, completion: nil)
    }
}

