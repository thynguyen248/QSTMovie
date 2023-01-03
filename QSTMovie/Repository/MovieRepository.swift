//
//  MovieRepository.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/30/22.
//

import Combine

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
                if resultList.isEmpty {
                    return self?.dbHandler.saveMovieList(movieList: fake) ?? Empty().eraseToAnyPublisher()
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

let fake = [
    MovieModel(identifier: "tenet",
               title: "Tenet",
               description: "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.",
               rating: 7.8,
               duration: "2h 30min",
               genre: "Action, Sci-Fi",
               releasedDate: "3 September 2020".convertToDate(),
               trailerLink: "​https://www.youtube.com/watch?v=LdOM0x0XDMo",
               inWatchList: false),
    MovieModel(identifier: "spider-man",
               title: "Spider-Man: Into the Spider-Verse",
               description: "Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions to stop a threat for all realities.",
               rating: 8.4,
               duration: "1h 57min",
               genre: "Action, Animation, Adventure",
               releasedDate: "14 December 2018".convertToDate(),
               trailerLink: "​​https://www.youtube.com/watch?v=tg52up16eq0",
               inWatchList: false),
    MovieModel(identifier: "knives-out",
               title: "Knives Out",
               description: "A detective investigates the death of a patriarch of an eccentric, combative family.",
               rating: 7.9,
               duration: "2h 10min",
               genre: "Comedy, Crime, Drama",
               releasedDate: "27 November 2019".convertToDate(),
               trailerLink: "​https://www.youtube.com/watch?v=qGqiHJTsRkQ",
               inWatchList: false),
    MovieModel(identifier: "guardians-of-the-galaxy",
               title: "Guardians of the Galaxy",
               description: "A group of intergalactic criminals must pull together to stop a fanatical warrior with plans to purge the universe.",
               rating: 8.0,
               duration: "2h 1min",
               genre: "Action, Adventure, Comedy",
               releasedDate: "1 August 2014".convertToDate(),
               trailerLink: "​https://www.youtube.com/watch?v=d96cjJhvlMA",
               inWatchList: false),
    MovieModel(identifier: "avengers",
               title: "Avengers: Age of Ultron",
               description: "When Tony Stark and Bruce Banner try to jump-start a dormant peacekeeping program called Ultron, things go horribly wrong and it's up to Earth's mightiest heroes to stop the villainous Ultron from enacting his terrible plan.",
               rating: 7.3,
               duration: "2h 21min",
               genre: "Action, Adventure, Sci-Fi",
               releasedDate: "1 May 2015".convertToDate(),
               trailerLink: "​https://www.youtube.com/watch?v=tmeOjFno6Do",
               inWatchList: false)
]
