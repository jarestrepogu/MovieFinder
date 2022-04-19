//
//  DetailsViewController.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let facade = FacadeMovieFinder()
    private var movieId = 0

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVotes: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Movie Id in Details view is \(movieId)")
    }
    
    @IBAction func whereToWatchPressed(_ sender: UIButton) {        
        self.performSegue(withIdentifier: "goToWatch", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProvidersViewController
        destinationVC.loadViewIfNeeded()
        
        facade.fetchProviders(movieId: movieId, completionHandler: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let providers):
                    print("The Main has the providers \(providers)")
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
    func storeMovieId(_ movieId: Int) {
        self.movieId = movieId
    }
}
