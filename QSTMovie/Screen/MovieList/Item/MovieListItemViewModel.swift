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
    
    var id: String {
        return "\(itemId), \(inWatchList)"
    }
}

extension MovieListItemViewModel {
    init(movieModel: MovieModel) {
        itemId = movieModel.identifier
        title = "\(movieModel.title ?? "") (\(movieModel.releasedDate?.convertToString() ?? ""))"
        subTitle = "\(movieModel.duration ?? "") - \(movieModel.genre ?? "")"
        inWatchList = movieModel.inWatchList ?? false
    }
}
