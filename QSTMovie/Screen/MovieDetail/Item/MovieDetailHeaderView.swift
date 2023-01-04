//
//  MovieDetailHeaderView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/3/23.
//

import SwiftUI

struct MovieDetailHeaderView: View {
    let movieModel: MovieModel
    @Binding var inWatchList: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            Image(movieModel.identifier)
                .resizable()
                .frame(width: Constants.posterSize.width, height: Constants.posterSize.height)
                .cornerRadius(5)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
            VStack(alignment: .leading, spacing: 16.0) {
                HStack {
                    Text(movieModel.title ?? "")
                        .foregroundColor(.primary)
                        .font(.system(size: 18.0, weight: .bold))
                    Spacer()
                    ratingView
                }
                Button(action: {
                    inWatchList.toggle()
                }) {
                    Text(
                        inWatchList ? "REMOVE FROM WATCHLIST" : "+ ADD TO WATCHLIST"
                    )
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 16))
                        .padding()
                        .foregroundColor(.primary.opacity(0.7))
                }
                .background(.gray.opacity(0.5))
                .cornerRadius(25)
                Button(action: {
                }) {
                    Text("WATCH TRAILER")
                        .font(.system(size: 16))
                        .padding()
                        .foregroundColor(.black)
                }
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 1))
            }
        }
        .padding(.top)
        .padding(.bottom)
    }
    
    private var ratingView: some View {
        guard let rating = movieModel.rating
        else { return AnyView(EmptyView()) }
        let ratingText = "\(rating)"
        return AnyView(
            Text(ratingText)
                .foregroundColor(.primary)
                .font(.system(size: 18.0, weight: .bold)) +
            Text("/10")
                .foregroundColor(.gray)
                .font(.system(size: 15.0, weight: .regular))
        )
    }
}

struct MovieDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let movieModel = MovieModel(identifier: "spider-man",
                                    title: "Spider-Man: Into the Spider-Verse",
                                    description: "Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions to stop a threat for all realities.",
                                    rating: 8.4,
                                    duration: "1h 57min",
                                    genre: "Action, Animation, Adventure",
                                    releasedDate: "14 December 2018".toDate(formatter: .defaultDateFormatter),
                                    trailerLink: "​​https://www.youtube.com/watch?v=tg52up16eq0",
                                    inWatchList: false)
        MovieDetailHeaderView(movieModel: movieModel, inWatchList: .constant(true))
    }
}
