//
//  Utils.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import UIKit

//MARK: - Spinner View
fileprivate var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.159, green: 0.214, blue: 0.305, alpha: 1.0)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = UIColor.white
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
