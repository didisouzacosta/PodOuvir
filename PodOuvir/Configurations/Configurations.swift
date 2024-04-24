//
//  Configurations.swift
//  PodOuvir
//
//  Created by ProDoctor on 15/04/24.
//

import Foundation

struct Configurations {
    static var apiURL = Bundle.main.apiURL
}

fileprivate extension Bundle {
    
    var apiURL: URL {
        let url = infoDictionary!["API_URL"] as! String
        return URL(string: url)!
    }
    
}
