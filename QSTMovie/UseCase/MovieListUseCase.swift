//
//  MovieUseCase.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/30/22.
//

import Combine

protocol MovieListUseCaseInterface {
    func getMovieList(sortType: SortType) -> AnyPublisher<[MovieModel], AppError>
}

class MovieListUseCase: MovieListUseCaseInterface {
    private let movieRepository: MovieRepositoryInterface
    
    init(movieRepository: MovieRepositoryInterface = MovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func getMovieList(sortType: SortType) -> AnyPublisher<[MovieModel], AppError> {
        return movieRepository.getMovieList(sortType: sortType)
    }
}
