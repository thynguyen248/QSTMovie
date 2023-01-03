//
//  ViewModel.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
