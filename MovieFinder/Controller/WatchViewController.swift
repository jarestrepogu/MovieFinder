//
//  WatchViewController.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit
import Kingfisher

class WatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var movieId = 0
    var providerGroup: ProviderGroup?
    
    private var collectionView: UICollectionView?
    private var facade = FacadeMovieFinder()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        showSpinner()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: view.frame.width/3.3, height: view.frame.width/3.3)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(ProvidersViewCell.nib(), forCellWithReuseIdentifier: ProvidersViewCell.identifier)
        
        collectionView?.register(ProvidersHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor(named: "BlueBgColor")
        view.addSubview(collectionView!)
        
        print("Watch movie id is \(movieId)")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
        
    //MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        var sections = 0
        if providerGroup?.buy != nil {
            sections += 1
        }
        if providerGroup?.flatrate != nil {
            sections += 1
        }
        if providerGroup?.rent != nil {
            sections += 1
        }
        return sections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProvidersViewCell.identifier, for: indexPath) as! ProvidersViewCell
        if let poster = providerGroup?.flatrate?[indexPath.row].logoPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            cell.providerLogo.kf.setImage(with: posterURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
