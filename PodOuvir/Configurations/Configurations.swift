//
//  Configurations.swift
//  PodOuvir
//
//  Created by ProDoctor on 15/04/24.
//

import Foundation

struct Configurations {
    static var backendURL = Bundle.main.backendURL
}

fileprivate extension Bundle {
    
    var backendURL: URL {
        let url = infoDictionary!["BACKEND_URL"] as! String
        return URL(string: url)!
    }
    
}
