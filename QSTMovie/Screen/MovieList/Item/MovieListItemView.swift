//
//  MovieListItemView.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/2/23.
//

import SwiftUI

struct MovieListItemView: View {
    let itemViewModel: MovieListItemViewModel
    private let posterWidth: CGFloat = 120.0
    
    var body: some View {
        HStack(alignment: .center, spacing: 10.0) {
            Image(itemViewModel.itemId)
                .resizable()
                .frame(width: posterWidth, height: posterWidth * 3 / 2)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
            VStack(alignment: .leading, spacing: 10.0) {
                Text(itemViewModel.title)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
                    .font(.system(size: 18.0, weight: .bold))
                Text(itemViewModel.subTitle)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .font(.system(size: 16.0, weight: .regular))
                if itemViewModel.inWatchList {
                    Text("ON MY WATCHLIST")
                        .foregroundColor(.primary)
                        .font(.system(size: 14.0, weight: .regular))
                }
            }
        }
        .padding(.bottom, 8.0)
        .padding(.top, 8.0)
    }
}
