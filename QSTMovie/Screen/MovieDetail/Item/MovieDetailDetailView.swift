//
//  MovieDetailDetailView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import SwiftUI

struct MovieDetailDetailView: View {
    let movieModel: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text("Details")
                .foregroundColor(.primary)
                .font(.system(size: 18.0, weight: .bold))
            VStack(alignment: .center, spacing: 8.0) {
                HStack(spacing: 10) {
                    Text("Genre")
                        .foregroundColor(.black)
                        .font(.system(size: 16.0, weight: .regular))
                    Text(movieModel.genre ?? "")
                        .foregroundColor(.gray)
                        .font(.system(size: 16.0, weight: .regular))
                }
                HStack(spacing: 10) {
                    Text("Released date")
                        .foregroundColor(.black)
                        .font(.system(size: 16.0, weight: .regular))
                    Text(movieModel.releasedDate?.toString(formatter: .shortDateFormatter) ?? "")
                        .foregroundColor(.gray)
                        .font(.system(size: 16.0, weight: .regular))
                }
            }
            .frame( maxWidth: .infinity)
        }
        .padding(.top)
        .padding(.bottom)
    }
}

struct MovieDetailDetailView_Previews: PreviewProvider {
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
        MovieDetailDetailView(movieModel: movieModel)
    }
}
