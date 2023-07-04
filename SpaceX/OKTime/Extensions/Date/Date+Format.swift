//
//  Date+Format.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import Foundation
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.locale = Locale(identifier: "EN")
        return dateformat.string(from: self)
    }
}
