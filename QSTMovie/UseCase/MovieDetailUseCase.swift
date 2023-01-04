//
//  MovieDetailUseCase.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import Combine

protocol MovieDetailUseCaseInterface {
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError>
}

final class MovieDetailUseCase: MovieDetailUseCaseInterface {
    private let movieRepository: MovieRepositoryInterface
    
    init(movieRepository: MovieRepositoryInterface = MovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func addRemoveFromWatchList(movieId: String, add: Bool) -> AnyPublisher<Bool, AppError> {
        return movieRepository.addRemoveFromWatchList(movieId: movieId, add: add)
    }
}
