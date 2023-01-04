//
//  MovieRepository.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/30/22.
//

import Combine
import Foundation

protocol MovieRepositoryInterface {
    func getMovieList(sortType: SortType) -> AnyPublisher<[MovieModel], AppError>
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError>
}

final class MovieRepository: MovieRepositoryInterface {
    private let dbHandler: DBHandlerProtocol
    
    init(dbHandler: DBHandlerProtocol = CoreDataStack()) {
        self.dbHandler = dbHandler
    }
    
    func getMovieList(sortType: SortType) -> AnyPublisher<[MovieModel], AppError> {
        return dbHandler.fetchMovieList(predicate: nil, sortType: sortType, limit: nil)
            .flatMap { [weak self] resultList -> AnyPublisher<[MovieModel], AppError> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                if resultList.isEmpty {
                    let fake = [MovieModel].parse(jsonFile: "fake-movies") ?? []
                    return self.dbHandler.saveMovieList(movieList: fake)
                        .flatMap { _ in
                            self.dbHandler.fetchMovieList(predicate: nil, sortType: sortType, limit: nil)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(resultList)
                        .setFailureType(to: AppError.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError> {
        return dbHandler.addRemoveFromWatchList(movieId: movieId, add: add)
    }
}


