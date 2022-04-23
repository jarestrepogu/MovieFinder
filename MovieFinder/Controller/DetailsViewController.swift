//
//  DetailsViewController.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import UIKit
import Kingfisher

final class DetailsViewController: UIViewController {
    
    private var movie: Movie!
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    static func build(with movie: Movie) -> DetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "details") as! DetailsViewController
        destinationVC.movie = movie
        return destinationVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieTitle.text = movie.title
        movieVotes.text = String(movie.voteAverage)
        movieOverview.text = movie.overview
        if let poster = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            self.posterImage.kf.setImage(with: posterURL)
        }
    }
    
    @IBAction func whereToWatchPressed(_ sender: UIButton) {        
        let destinationVC = storyboard?.instantiateViewController(identifier: "providers") as! ProvidersViewController
        destinationVC.setMovieId(movie.id)
        destinationVC.modalPresentationStyle = .popover
        present(destinationVC, animated: true, completion: nil)
    }
}

