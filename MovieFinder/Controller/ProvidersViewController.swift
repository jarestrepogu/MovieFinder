//
//  ProvidersViewController.swift
//  MovieFinder
//
//  Created by Lina on 12/04/22.
//

import UIKit
import Kingfisher

class ProvidersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let facade = FacadeMovieFinder()
    private var movieId = 0
    private var providers: ProviderGroup?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "ProvidersViewCell", bundle: nil), forCellWithReuseIdentifier: "ProvidersViewCell")
        self.collectionView.register(ProvidersHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        showSpinner()
        facade.fetchProviders(movieId: movieId, completionHandler: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let providers):
                    self.setProviders(providers)
                    self.collectionView.reloadData()
                    self.removeSpinner()
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return providers?.buy?.count ?? 1
        case 1:
            return providers?.flatrate?.count ?? 1
        case 2:
            return providers?.rent?.count ?? 1
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersViewCell", for: indexPath) as! ProvidersViewCell
        
        switch indexPath.section {
        case 0:
            if let poster = providers?.buy?[indexPath.row].logoPath, let name = providers?.buy?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            } else {
                cell.providerName.text = Constants.nothingFound
            }
        case 1:
            if let poster = providers?.flatrate?[indexPath.row].logoPath, let name = providers?.flatrate?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            } else {
                cell.providerName.text = Constants.nothingFound
            }
        case 2:
            if let poster = providers?.rent?[indexPath.row].logoPath, let name = providers?.rent?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            } else {
                cell.providerName.text = Constants.nothingFound
            }
        default:
            cell.providerName.text = Constants.nothingFound
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier, for: indexPath) as! ProvidersHeaderView
        
        switch indexPath.section {
        case 0:
            header.configure(title: Constants.Providers.buyTitle)
            return header
        case 1:
            header.configure(title: Constants.Providers.flatRateTitle)
            return header
        case 2:
            header.configure(title: Constants.Providers.rentTitle)
            return header
        default:
            header.configure(title: Constants.Providers.noProviders)
            return header
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3.2, height: (view.frame.width / 3.2) + 14)
    }
    //MARK: - View Controller Setup
    func setProviders(_ providers: ProviderGroup) {
        self.providers = providers
    }
    func setMovieId(_ movieId: Int) {
        self.movieId = movieId
    }
}
