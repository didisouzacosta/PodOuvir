//
//  TimeIntervalExtension.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 14/04/24.
//

import Foundation

extension TimeInterval {
    
    var hourMinuteSecond: String {
        String(format:"%02d:%02d:%02d", hour, minute, second)
    }
    
    var minuteSecond: String {
        String(format:"%02d:%02d", minute, second)
    }
    
    var hour: Int {
        Int((validValue / 3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minute: Int {
        Int((validValue / 60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        Int(validValue.truncatingRemainder(dividingBy: 60))
    }
    
    var millisecond: Int {
        Int((validValue * 1000).truncatingRemainder(dividingBy: 1000))
    }
    
    // MARK: Private Varibles
    
    private var validValue: Self {
        guard !(self.isNaN || self.isInfinite) else { return 0 }
        return self
    }
}
