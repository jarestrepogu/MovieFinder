//
//  ProvidersHeaderView.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit

class ProvidersHeaderView: UICollectionReusableView {
    
    static let identifier = "ProvidersHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    func configure(title: String) {
        backgroundColor = UIColor(named: "BlueBgColor")
        label.text = title
        addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
        
}
