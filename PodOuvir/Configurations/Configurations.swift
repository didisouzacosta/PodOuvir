//
//  Configurations.swift
//  PodOuvir
//
//  Created by ProDoctor on 15/04/24.
//

import Foundation

struct Configurations {
    static var apiURL = Bundle.main.apiURL
    static var subscriptionGroupId = Bundle.main.subscriptionGroupId
}

fileprivate extension Bundle {
    
    var subscriptionGroupId: String {
        infoDictionary!["SUBSCRIPTION_GROUP_ID"] as! String
    }
    
    var apiURL: URL {
        let url = infoDictionary!["API_URL"] as! String
        return URL(string: url)!
    }
    
}
