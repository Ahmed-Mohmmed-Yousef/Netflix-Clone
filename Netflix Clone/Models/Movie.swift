//
//  Movie.swift
//  Netflix Clone
//
//  Created by Ahmed on 28/05/2022.
//

import Foundation

// MARK: - TrendingMoviesResponse
struct TrendingMoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let id, voteCount: Int
    let video: Bool
    let voteAverage: Double
    let title, overview, releaseDate, posterPath: String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case id
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
        case title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case popularity
    }
}


enum OriginalLanguage: String, Codable {
    case en = "en"
}
