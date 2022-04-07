//
//  ProvidersData.swift
//  MovieFinder
//
//  Created by Lina on 4/04/22.
//

import Foundation

// MARK: - ProvidersData
struct ProvidersData: Codable {
    let results: Results
}

// MARK: - Results
struct Results: Codable {
    let ar: Country
    let at: Country
    let au: Country
    let be: Country
    let br: Country
    let ca: Country
    let ch: Country
    let cl: Country
    let co: Country
    let cz: Country
    let de: Country
    let dk: Country
    let ec: Country
    let ee: Country
    let es: Country
    let fi: Country
    let fr: Country
    let gb: Country
    let gr: Country
    let hu: Country
    let id: Country
    let ie: Country
    let `in`: Country
    let `is`: Country
    let it: Country
    let jp: Country
    let kr: Country
    let lt: Country
    let lv: Country
    let mx: Country
    let my: Country
    let nl: Country
    let no: Country
    let nz: Country
    let pe: Country
    let ph: Country
    let pl: Country
    let pt: Country
    let ro: Country
    let ru: Country
    let se: Country
    let sg: Country
    let th: Country
    let tr: Country
    let us: Country
    let ve: Country
    let za: Country

    enum CodingKeys: String, CodingKey {
        case ar
        case at
        case au
        case be
        case br
        case ca
        case ch
        case cl
        case co
        case cz
        case de
        case dk
        case ec
        case ee
        case es
        case fi
        case fr
        case gb
        case gr
        case hu
        case id
        case ie
        case `in`        
        case `is`
        case it
        case jp
        case kr
        case lt
        case lv
        case mx
        case my
        case nl
        case no
        case nz
        case pe
        case ph
        case pl
        case pt
        case ro
        case ru
        case se
        case sg
        case th
        case tr
        case us
        case ve
        case za
    }
}

// MARK: - Country
struct Country: Codable {
    let flatrate: [Buy]?
    let rent: [Buy]?
    let buy: [Buy]?

    enum CodingKeys: String, CodingKey {
        case flatrate
        case rent
        case buy
    }
}

// MARK: - Buy
struct Buy: Codable {
    let logoPath: String
}
