//
//  MovieDetailView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import SwiftUI
import Combine

enum MovieDetailRowType: Int, CaseIterable, Identifiable {
    case header = 0
    case description
    case detail
    
    var id: Int {
        return rawValue
    }
}

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        List {
            ForEach(MovieDetailRowType.allCases) { type in
                containedView(type: type)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("", displayMode: .inline)
        .errorAlert(isPresented: Binding<Bool>(
            get: { viewModel.error != nil },
            set: { _ in }
        ), error: viewModel.error)
    }
    
    func containedView(type: MovieDetailRowType) -> some View {
        switch type {
        case .header:
            return AnyView(
                MovieDetailHeaderView(movieModel: viewModel.movieModel, inWatchList: Binding<Bool>(get: {
                    return viewModel.inWatchList
                }, set: { value in
                    viewModel.addToWatchListTrigger.send(value)
                })))
        case .description:
            return AnyView(MovieDetailDescriptionView(movieModel: viewModel.movieModel))
        case .detail:
            return AnyView(MovieDetailDetailView(movieModel: viewModel.movieModel))
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let movieModel = MovieModel(identifier: "tenet",
                                    title: "Tenet",
                                    description: "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.",
                                    rating: 7.8,
                                    duration: "2h 30min",
                                    genre: "Action, Sci-Fi",
                                    releasedDate: "3 September 2020".toDate(formatter: .defaultDateFormatter),
                                    trailerLink: "​https://www.youtube.com/watch?v=LdOM0x0XDMo",
                                    inWatchList: true)
        let viewModel = MovieDetailViewModel(movieModel: movieModel)
        return MovieDetailView(viewModel: viewModel)
    }
}
