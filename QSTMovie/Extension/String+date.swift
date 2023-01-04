//
//  String+date.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//

import Foundation

extension String {
    func toDate(formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
}

extension Date {
    func toString(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    var year: Int? {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year
    }
}
