//
//  ViewController.swift
//  MovieFinder
//
//  Created by Lina on 28/03/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageTest: UIImageView!
    
    private var movieManager = MovieManager()
    private var posterManager = PosterManager()
    private let webHelper = WebHelper()
    private let apiKey = ApiKeys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate{
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Enter movie title to search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let movie = searchTextField.text {
            movieManager.fetchMovie(url: webHelper.apiURL(movieTitle: movie, apiKey: apiKey.tmdbKey))
        }
        searchTextField.text = ""
    }
    
}

//MARK: - MovieManagerDelegate

extension ViewController: MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        print(movie[0].overview)
        
        DispatchQueue.main.async {
            if let poster = movie[0].posterPath {
                let posterURL = URL(string: self.posterManager.fetchPosterURL(posterPath: poster))
                self.imageTest.kf.setImage(with: posterURL)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
