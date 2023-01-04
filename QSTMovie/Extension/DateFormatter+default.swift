//
//  DateFormatter+default.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/4/23.
//

import UIKit

extension DateFormatter {
    static let defaultDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy, dd MMMM"
        return dateFormatter
    }()
}
