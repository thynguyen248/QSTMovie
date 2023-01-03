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
    //    associatedtype ObjectType
    //    associatedtype PredicateType
    //
    //    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType?, limit: Int?) -> AnyPublisher<[ObjectType], Error>
    //    func save(objects: [ObjectType], objectType: ObjectType.Type) -> AnyPublisher<Void, Error>
    
    func fetchMovieList(predicate: NSPredicate?, sortType: SortType?, limit: Int?) -> AnyPublisher<[MovieModel], AppError>
    func saveMovieList(movieList: [MovieModel]) -> AnyPublisher<[MovieModel], AppError>
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError>
}

enum SortType: String, CaseIterable {
    case title = "Title"
    case releasedDate = "Released Date"
}

enum ChangeType {
  case inserted, deleted, updated

  var userInfoKey: String {
    switch self {
    case .inserted: return NSInsertedObjectIDsKey
    case .deleted: return NSDeletedObjectIDsKey
    case .updated: return NSUpdatedObjectIDsKey
    }
  }
}
