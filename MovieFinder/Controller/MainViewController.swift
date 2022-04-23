//
//  MainViewController.swift
//  MovieFinder
//
//  Created by Lina on 31/03/22.
//

import UIKit
import Kingfisher

final class MainViewController: UITableViewController {
    
    @IBOutlet weak var backbutton: UIBarButtonItem!
    @IBOutlet weak var searchMovieBar: UISearchBar!
    
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MovieCell", bundle: nil),
                           forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = 175
        
        viewModel.isLoadingHandler = { [unowned self] isLoading in
            isLoading ? self.showSpinner() : self.removeSpinner()
        }
        viewModel.moviesDidChanged = { [unowned self] in
            self.title = viewModel.title
            self.tableView.reloadData()
            self.showBackButtonIfNeeded()
        }
        viewModel.errorHandler = { [unowned self] error in
            var errorTitle = ""
            
            switch error {
            case .emptyResponse:
                errorTitle = Constants.nothingFound
            case .error(let error):
                errorTitle = error.localizedDescription
            }
            
            let nothingAlert = UIAlertController(
                title: errorTitle,
                message: nil,
                preferredStyle: .alert
            )
            self.present(nothingAlert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.dismiss(animated: true, completion: nil)
                self.viewModel.stopSeaching()
            }
        }
        viewModel.fetchMovies()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: Constants.searchMovie, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.searchTitle, style: .default) { [unowned self] (action) in
            if let query = textField.text, !query.isEmpty {
                viewModel.search(movieQuery: query)
            } else {
                print("Nothing added")
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = Constants.searchMovie
            textField = alertTextField
        }
        alert.addAction(action)        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Back to Trending Button
    func showBackButtonIfNeeded() {
        let needsBackButton = viewModel.isSearching
        
        if needsBackButton && navigationItem.leftBarButtonItem == nil {
            self.navigationItem.leftBarButtonItem = createBackButton()
        } else if !needsBackButton {
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
    }
    
    private func createBackButton() -> UIBarButtonItem {
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed(_ :))
        )
        leftButton.tintColor = UIColor.white
        return leftButton
    }
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        viewModel.stopSeaching()
    }
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movies[indexPath.row]
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
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let destinationVC = DetailsViewController.build(with: movie)
        
        destinationVC.modalPresentationStyle = .popover
        present(destinationVC, animated: true, completion: nil)
    }
}
