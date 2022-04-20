//
//  ProvidersData.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import Foundation

struct ProvidersData: Decodable {
    let results: [String: ProviderGroup]
}
struct ProviderGroup: Decodable {
    let flatrate: [Provider]?
    let buy: [Provider]?
    let rent: [Provider]?
}
struct Provider: Decodable {
    let providerId: Int
    let providerName: String
    let logoPath: String
}
