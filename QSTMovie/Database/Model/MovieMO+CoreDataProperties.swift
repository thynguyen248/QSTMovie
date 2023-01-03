//
//  MovieMO+CoreDataProperties.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/1/23.
//
//

import Foundation
import CoreData


extension MovieMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieMO> {
        return NSFetchRequest<MovieMO>(entityName: "MovieMO")
    }

    @NSManaged public var desc: String?
    @NSManaged public var duration: String?
    @NSManaged public var genre: String?
    @NSManaged public var identifier: String
    @NSManaged public var inWatchList: Bool
    @NSManaged public var posterLink: String?
    @NSManaged public var rating: Double
    @NSManaged public var releasedDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var trailerLink: String?

}

extension MovieMO : Identifiable {

}

extension MovieMO {
    func update(with movieModel: MovieModel) {
        self.identifier = movieModel.identifier
        self.title = movieModel.title
        self.desc = movieModel.description
        self.rating = movieModel.rating ?? 0
        self.duration = movieModel.duration
        self.genre = movieModel.genre
        self.releasedDate = movieModel.releasedDate
        self.trailerLink = movieModel.trailerLink
        self.inWatchList = movieModel.inWatchList ?? false
    }
    
    var movieModel: MovieModel {
        return MovieModel(identifier: identifier,
                          title: title,
                          description: desc,
                          rating: rating,
                          duration: duration,
                          genre: genre,
                          releasedDate: releasedDate,
                          trailerLink: trailerLink,
                          inWatchList: inWatchList)
    }
}
