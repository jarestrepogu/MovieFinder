//
//  ProvidersData.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import Foundation

// MARK: - ProvidersData
struct ProvidersData: Decodable {
    let results: [String: ProviderGroup]
}

struct Provider: Decodable {
    let providerId: Int
    let providerName: String
    let logoPath: String
}

struct ProviderGroup: Decodable {
    let flatrate: [Provider]?
    let buy: [Provider]?
    let rent: [Provider]?
}
