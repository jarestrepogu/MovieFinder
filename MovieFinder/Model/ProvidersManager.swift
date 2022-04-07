//
//  ProvidersManager.swift
//  MovieFinder
//
//  Created by Lina on 6/04/22.
//

import UIKit

protocol ProvidersManagerDelegate {
    func didUpdateProviders(_ providersManager: ProvidersManager, providers: ProvidersModel)
    func didFailWithError(error: Error)
}

struct ProvidersManager{
    
    var delegate: ProvidersManagerDelegate?
    
    func fetchProviders(url: URL, countryCode: String){
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let providers = self.parseJSON(safeData, countryCode){
                self.delegate?.didUpdateProviders(self, providers: providers)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ providersData: Data,_ countryCode: String) -> ProvidersModel?{
        //        let decoder = JSONDecoder()
        
        var fr: [Provider] = []
        var b: [Provider] = []
        var r: [Provider] = []
        
        if let decodedData = try? JSONSerialization.jsonObject(with: providersData, options: []) as? [String: Any]{
            
            if let results = decodedData["results"] as? [String: Any]{
                if let countryResult = results.filter ({ (resultEntry) -> Bool in
                    let (key, _) = resultEntry
                    return countryCode == key
                })[countryCode] as? [String: Any] {
                    
                    if let flatrate = countryResult["flatrate"] as? [[String: Any]]{
                        for i in 0...flatrate.count - 1{
                            let frResult = Provider(logoPath: flatrate[i]["logo_path"]! as! String, name: flatrate[i]["provider_name"]! as! String)
                            fr.append(frResult)
                        }
                    }
                    if let buy = countryResult["buy"] as? [[String: Any]]{
                        for i in 0...buy.count - 1{
                            let bResult = Provider(logoPath: buy[i]["logo_path"]! as! String, name: buy[i]["provider_name"]! as! String)
                            b.append(bResult)
                        }
                    }
                    if let rent = countryResult["rent"] as? [[String: Any]]{
                        for i in 0...rent.count - 1{
                            let rResult = Provider(logoPath: rent[i]["logo_path"]! as! String, name: rent[i]["provider_name"]! as! String)
                            r.append(rResult)
                        }
                    }
                }
                let providers = ProvidersModel(flatrate: fr, rent: r, buy: b)
                return providers
            }
        }
//        delegate?.didFailWithError(error: error)
        return nil
    }
}
