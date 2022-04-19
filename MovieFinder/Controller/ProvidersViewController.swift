//
//  ProvidersViewController.swift
//  MovieFinder
//
//  Created by Lina on 12/04/22.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "ProvidersViewCell"

class ProvidersViewController: UICollectionViewController {
    
    private let facade = FacadeMovieFinder()
    private var providers: ProviderGroup?
    private var sections = 0
    private var cells = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProvidersViewCell
        
        if indexPath.section == 0 {
            if let poster = providers?.buy?[indexPath.row].logoPath, let name = providers?.buy?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            }
        }
        if indexPath.section == 1 {
            if let poster = providers?.flatrate?[indexPath.row].logoPath, let name = providers?.flatrate?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            }
        }
        if indexPath.section == 2 {
            if let poster = providers?.rent?[indexPath.row].logoPath, let name = providers?.rent?[indexPath.row].providerName {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                cell.providerLogo.kf.setImage(with: posterURL)
                cell.providerName.text = name
            }
        } else {
            cell.providerLogo.image = UIImage(named: "eye.slash")
            cell.providerName.text = "Nothing"
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier, for: indexPath) as! ProvidersHeaderView
        
        if indexPath.section == 0 {
            header.configure(title: "Where to buy:")
            return header
        }
        if indexPath.section == 1 {
            header.configure(title: "Watch on:")
            return header
        }
        if indexPath.section == 2 {
            header.configure(title: "Where to rent:")
            return header
        } else {
            header.configure(title: "No providers in your region.")
            return header
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
}
