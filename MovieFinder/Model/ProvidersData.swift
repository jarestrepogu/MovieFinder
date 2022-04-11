//
//  ProvidersData.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import Foundation

// MARK: - ProvidersData
struct ProvidersData: Codable {
    let results: [String: ProviderGroup]
}

struct Provider: Codable {
    let providerId: Int
    let providerName: String
    let logoPath: String
}

struct ProviderGroup: Codable {
    let flatrate: [Provider]?
    let buy: [Provider]?
    let rent: [Provider]?
}
