//
//  ProvidersViewCell.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit

class ProvidersViewCell: UICollectionViewCell {
    
    static let identifier = "ProvidersViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProvidersViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .orange
    }

}
