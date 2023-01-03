//
//  MovieDetailUseCase.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import Foundation

protocol MovieDetailUseCaseInterface {
    func addRemoveFromWatchList(movieId: String, add: Bool)
}

class MovieDetailUseCase: MovieDetailUseCaseInterface {
    private let movieRepository: MovieRepositoryInterface
    
    init(movieRepository: MovieRepositoryInterface = MovieRepository()) {
        self.movieRepository = movieRepository
    }
    
    func addRemoveFromWatchList(movieId: String, add: Bool) {
        return movieRepository.addRemoveFromWatchList(movieId: movieId, add: add)
    }
}
