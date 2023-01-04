//
//  AppError.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case dbFetchError(_ message: String)
    case dbInsertError(_ message: String)
    case unknownError
    
    var message: String {
        switch self {
        case .dbFetchError(let message):
            return message
        case .dbInsertError(let message):
            return message
        case .unknownError:
            return "Unknown error"
        }
    }
}
