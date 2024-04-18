//
//  SafeArray.swift
//  PodOuvir
//
//  Created by ProDoctor on 18/04/24.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
    
}
