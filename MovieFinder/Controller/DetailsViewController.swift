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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func whereToWatchPressed(_ sender: UIButton) {
        
        
        performSegue(withIdentifier: "goToWatch", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
