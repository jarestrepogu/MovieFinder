//
//  WatchViewController.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit

class WatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProvidersManagerDelegate {
    
    
    private var collectionView: UICollectionView?
    private var providers = ProvidersManager()
    private var webHelper = WebHelper()
    private var apiKey = ApiKeys()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        providers.delegate = self
        providers.fetchProviders(url: webHelper.whereToWatchURL(movieId: "597", apiKey: apiKey.tmdbKey), countryCode: "CO")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProvidersViewCell.identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProvidersHeaderView.identifier, for: indexPath) as! ProvidersHeaderView
        
        header.configure(title: "The actual header!")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    
    func didUpdateProviders(_ providersManager: ProvidersManager, providers: ProvidersModel) {
        print(providers.flatrate?[0].logoPath)
        print(providers.rent?[0].name)
        print(providers.buy?[0].logoPath)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}