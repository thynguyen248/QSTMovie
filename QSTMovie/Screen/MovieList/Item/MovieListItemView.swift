//
//  MovieListItemView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/2/23.
//

import SwiftUI

struct MovieListItemView: View {
    let itemViewModel: MovieListItemViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10.0) {
            Image(itemViewModel.itemId)
                .resizable()
                .frame(width: Constants.posterSize.width, height: Constants.posterSize.height)
                .cornerRadius(5)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
            VStack(alignment: .leading, spacing: 10.0) {
                Text(itemViewModel.title)
                    .foregroundColor(.primary)
                    .font(.system(size: 16.0, weight: .bold))
                Text(itemViewModel.subTitle)
                    .foregroundColor(.secondary)
                    .font(.system(size: 14.0, weight: .regular))
                if itemViewModel.inWatchList {
                    Text("ON MY WATCHLIST")
                        .foregroundColor(.primary)
                        .font(.system(size: 14.0, weight: .medium))
                        .padding(.top)
                }
            }
        }
        .padding(.bottom, 8.0)
        .padding(.top, 8.0)
    }
}

struct MovieListItemView_Previews: PreviewProvider {
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
        
        let viewModel = MovieListItemViewModel(movieModel: movieModel)
        MovieListItemView(itemViewModel: viewModel)
    }
}
