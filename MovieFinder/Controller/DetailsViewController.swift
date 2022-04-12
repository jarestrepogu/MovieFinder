//
//  DetailsViewController.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    private var movieId = 0
    
    let facade = FacadeMovieFinder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setMovieId(id: Int) {
        movieId = id
    }
    
    @IBAction func whereToWatchPressed(_ sender: UIButton) {
        showSpinner()
        print("Details movie id is \(movieId)")
        performSegue(withIdentifier: "goToWatch", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WatchViewController
        destinationVC.movieId = movieId
        
        facade.fetchProviders(movieId: movieId, completionHandler: {result in
            DispatchQueue.main.async {                
                switch result {
                case .success(let providers):
                    destinationVC.providerGroup = providers
                    
                case .failure(let error):
                    print(error)
                }
                self.removeSpinner()
            }
        })
    }
}
