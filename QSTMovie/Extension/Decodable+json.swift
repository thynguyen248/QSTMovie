//
//  MovieModel+json.swift
//  QSTMovie
//
//  Created by Thy Nguyen on 1/4/23.
//

import Foundation

extension Decodable {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.defaultDateFormatter)
        return decoder
    }
    
    static func parse(jsonFile: String) -> Self? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let output = try? defaultDecoder.decode(self, from: data)
        else {
            return nil
        }
        return output
    }
}
