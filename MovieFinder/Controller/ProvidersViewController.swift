//
//  ProvidersViewController.swift
//  MovieFinder
//
//  Created by Lina on 12/04/22.
//

import UIKit
import Kingfisher

final class ProvidersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var viewModel = ProvidersViewModel()
    private var movieId: Int!
    
    static func build(with movieId: Int) -> ProvidersViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "providers") as! ProvidersViewController
        destinationVC.movieId = movieId
        return destinationVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ProvidersViewCell", bundle: nil), forCellWithReuseIdentifier: "ProvidersViewCell")
        self.collectionView.register(ProvidersHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier)
        
        viewModel.movieId = movieId
        viewModel.isLoadingHandler = { [unowned self] isLoading in isLoading ? self.showSpinner() : self.removeSpinner()
        }
        viewModel.providersDidChange = { [unowned self] in
            self.collectionView.reloadData()
        }
        viewModel.errorHandler = { error in
            switch error {
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        viewModel.fetchProviders()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.providers?.buy?.count ?? 0
        case 1:
            return viewModel.providers?.flatrate?.count ?? 0
        case 2:
            return viewModel.providers?.rent?.count ?? 0
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersViewCell", for: indexPath) as! ProvidersViewCell
        
        switch indexPath.section {
        case 0:
            if let poster = viewModel.providers?.buy?[indexPath.row].logoPath, let name = viewModel.providers?.buy?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            } else {
                cell.providerName.text = Constants.nothingFound
            }
        case 1:
            if let poster = viewModel.providers?.flatrate?[indexPath.row].logoPath, let name = viewModel.providers?.flatrate?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            } else {
                cell.providerName.text = Constants.nothingFound
            }
        case 2:
            if let poster = viewModel.providers?.rent?[indexPath.row].logoPath, let name = viewModel.providers?.rent?[indexPath.row].providerName {
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
}
