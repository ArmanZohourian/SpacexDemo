//
//  TimeInterval+Timer.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import Foundation



extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}
