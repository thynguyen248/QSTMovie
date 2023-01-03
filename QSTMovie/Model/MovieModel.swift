//
//  MovieModel.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 12/30/22.
//

import UIKit

struct MovieModel: Decodable {
    let identifier: String
    let title: String?
    let description: String?
    let rating: Double?
    let duration: String?
    let genre: String?
    let releasedDate: Date?
    let trailerLink: String?
    let inWatchList: Bool?
}
