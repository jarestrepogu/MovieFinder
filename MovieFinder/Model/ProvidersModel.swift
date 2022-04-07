//
//  ProvidersModel.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import Foundation

struct ProvidersModel {
    let flatrate: [Provider]?
    let rent: [Provider]?
    let buy: [Provider]?
}

struct  Provider {
    let logoPath: String
    let name: String
}
