//
//  MovieListItemViewModel.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//

import Foundation

struct MovieListItemViewModel: Identifiable {
    let itemId: String
    let title: String
    let subTitle: String
    let inWatchList: Bool
    let model: MovieModel
    
    var id: String {
        return "\(itemId), \(inWatchList)"
    }
}

extension MovieListItemViewModel {
    init(movieModel: MovieModel) {
        itemId = movieModel.identifier
        var yearText: String?
        if let year = movieModel.releasedDate?.year {
            yearText = "(\(year))"
        }
        title = [movieModel.title, yearText]
            .compactMap { $0 }
            .joined(separator: " ")
        subTitle = [movieModel.genre, movieModel.duration]
            .compactMap { $0 }
            .joined(separator: " - ")
        inWatchList = movieModel.inWatchList ?? false
        model = movieModel
    }
}
