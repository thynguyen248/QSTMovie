//
//  MovieDetailViewModel.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import Combine
import Foundation

final class MovieDetailViewModel: ObservableObject {
    let movieModel: MovieModel
    private let movieDetailUseCase: MovieDetailUseCase
    
    //Input
    let addToWatchListTrigger = PassthroughSubject<Bool, Never>()
    
    //Output
    @Published var inWatchList: Bool
    @Published var error: AppError?
    
    init(movieModel: MovieModel,
         movieDetailUseCase: MovieDetailUseCase = MovieDetailUseCase()) {
        self.movieModel = movieModel
        self.movieDetailUseCase = movieDetailUseCase
        self.inWatchList = movieModel.inWatchList ?? false
        binding()
    }
    
    func binding() {
        addRemovePublisher
            .map { [weak self] result -> Bool in
                guard let self = self else { return false }
                if case .success(let success) = result {
                    return success ? !self.inWatchList : self.inWatchList
                }
                return self.inWatchList
            }
            .assign(to: &$inWatchList)
        
        addRemovePublisher
            .map { result -> AppError? in
                if case .failure(let error) = result {
                    return error
                }
                return nil
            }
            .assign(to: &$error)
    }
    
    private lazy var addRemovePublisher: AnyPublisher<Result<Bool, AppError>, Never> = {
        return addToWatchListTrigger
            .flatMap { [movieModel, movieDetailUseCase] add in
                movieDetailUseCase.addRemoveFromWatchList(movieId: movieModel.identifier, add: add)
                    .asResult()
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
}
