//
//  DBHelperProtocol.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/29/22.
//

import Combine
import Foundation
import CoreData

protocol DBHandlerProtocol {
    func fetchMovieList(predicate: NSPredicate?, sortType: SortType?, limit: Int?) -> AnyPublisher<[MovieModel], AppError>
    func saveMovieList(movieList: [MovieModel]) -> AnyPublisher<[MovieModel], AppError>
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError>
}

enum SortType: String, CaseIterable {
    case title = "Title"
    case releasedDate = "Released Date"
}
