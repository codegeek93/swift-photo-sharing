//
//  Utility.swift
//  memories
//
//  Created by Toan Nguyen Dinh on 11/13/19.
//  Copyright © 2019 Toan Nguyen Dinh. All rights reserved.
//

import Foundation

class Utility: NSObject {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        return timeHMSFormatter.string(from: seconds) ?? "00:00"
    }
    
}
