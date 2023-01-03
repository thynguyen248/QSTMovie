//
//  MovieListViewModel.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//

import Combine
import Foundation

class MovieListViewModel: ObservableObject {
    private let movieListUseCase: MovieListUseCaseInterface
    
    //Input
    let loadTrigger = PassthroughSubject<Void, Never>()
    let sortTypeTrigger = CurrentValueSubject<SortType, Never>(.releasedDate)
    let addToWatchListTrigger = CurrentValueSubject<String?, Never>(nil)
    let selectMovieTrigger = CurrentValueSubject<String?, Never>(nil)
    
    //Output
    @Published var dataSource: [MovieListItemViewModel] = []
    @Published var sortTypes: [SortType] = SortType.allCases
    @Published var error: AppError?
    
    init(movieListUseCase: MovieListUseCaseInterface = MovieListUseCase()) {
        self.movieListUseCase = movieListUseCase
        binding()
    }
    
    private lazy var movieModelsPublisher: AnyPublisher<Result<[MovieModel], AppError>, Never> = {
        return Publishers.CombineLatest(loadTrigger, sortTypeTrigger)
            .flatMap { [movieListUseCase] (_, sortType) in
                return movieListUseCase.getMovieList(sortType: sortType)
                    .asResult()
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
    
    private func binding() {
        movieModelsPublisher
            .map { result -> AppError? in
                if case .failure(let error) = result {
                    return error
                }
                return nil
            }
            .assign(to: &$error)
        
        movieModelsPublisher
            .map { result -> [MovieListItemViewModel] in
                if case .success(let models) = result {
                    return models.map { MovieListItemViewModel(movieModel: $0) }
                }
                return []
            }
            .assign(to: &$dataSource)
    }
}
